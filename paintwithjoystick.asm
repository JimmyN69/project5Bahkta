#run this test once you have hooked up your RGBmonitor, keyboard, and memory
.data
.text
.globl main
boot:
    addi $sp, $0, 1023
    sll $sp, $sp, 16 #initialize $sp to 0x04000000
    j main #not really needed since main is the next line
main:
    addi $sp, $sp, -48
    #Store RGB values in a stack allocated array
    #Mixing palette
    addi $t0, $0, 255 #blue
    sll $t1, $t0, 8  #green
    sll $t2, $t0, 16 #red
    addi $t3, $0, 127 #less blue
    sll $t4, $t3, 8 #less green
    sll $t5, $t3, 16 #less red
    #red - 0
    sw $t2, 0($sp)
    #red-orange - 1
    add $t8, $t2, $t4
    sw $t8, 4($sp)
    #yellow - 2
    add $t8, $t2, $t1
    sw $t8, 8($sp)
    #green-yellow - 3
    add $t8, $t5, $t1
    sw $t8, 12($sp)
    #green - 4
    sw $t1, 16($sp)
    #cyan-green - 5
    add $t8, $t3, $t1
    sw $t8, 20($sp)
    #cyan-6
    add $t8, $t0, $t1
    sw $t8, 24($sp)
    #cyan-blue
    add $t8, $t0, $t4
    sw $t8, 28($sp)
    #blue - 8
    sw $t0, 32($sp)
    #blue-magenta - 9
    add $t8, $t0, $t5
    sw $t8, 36($sp)
    #magenta - 10
    add $t8, $t0, $t2
    sw $t8, 40($sp)
    #red-magenta - 11
    add $t8, $t3, $t2
    sw $t8, 44($sp)

    addi $s0, $0, 128 #x coordinate
    addi $s1, $0, 128 #y coordinate
    addi $s2, $0, 0 #color

loop:
    #check for joystick
    addi $v0, $0, 13
    syscall
    
    #check if joystick is in Use
    addi $t0, $0, 136
    beq $v0, $t0, colorchange

    #get x
    andi $t1, $v0, 15
    #gets y
    srl $v0, $v0, 4
    andi $t2, $v0, 15

    addi $t0, $0, 5
    slt $t3, $t1, $t0
    bne $t3, $0, moveleft
    addi $t0, $0, 11
    slt $t3, $t0, $t1
    bne $t3, $0, moveright
    j updatey

updatey:
    addi $t0, $0, 5
    slt $t3, $t2, $t0
    bne $t3, $0, moveup
    addi $t0, $0, 11
    slt $t3, $t0, $t2
    bne $t3, $0, movedown
    j updatepixel

updatepixel:
    j colorchange
    
moveleft:
    addi $s0, $s0, -1
    j updatey

moveright:
    addi $s0, $s0, 1
    j updatey

moveup:
    addi $s1, $s1, -1
    j updatepixel

movedown:
    addi $s1, $s1, 1
    j updatepixel


colorchange:
    #change color
    addi $s2, $s2, 1
    addi $t0, $0, 12
    div $s2, $t0
    mfhi $s2 #s2 = (s2 + 1) % 12
    sll $t0, $s2, 2
    add $t0, $t0, $sp #get address of color
    lw $t0, 0($t0) #t0 = load rgb color from memory
    #display pixel
    sw $s0, -4064($0) #0xFFFFF020 = monitor x coordinate
    sw $s1, -4060($0) #0xFFFFF024 = monitor y coordinate
    sw $t0, -4056($0) #0xFFFFF028 = monitor color
    sw $0, -4052($0)  #0xFFFFF02C = write pixel
    j loop