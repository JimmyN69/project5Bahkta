#This is starter code, so that you know the basic format of this file.
#Use _ in your system labels to decrease the chance that labels in the "main"
#program will conflict

.data

.text
_syscallStart_:
    beq $v0, $0, _syscall0 #jump to syscall 0
    addi $k1, $0, 1
    beq $v0, $k1, _syscall1 #jump to syscall 1
    addi $k1, $0, 5
    beq $v0, $k1, _syscall5 #jump to syscall 5
    addi $k1, $0, 9
    beq $v0, $k1, _syscall9 #jump to syscall 9
    addi $k1, $0, 10
    beq $v0, $k1, _syscall10 #jump to syscall 10
    addi $k1, $0, 11
    beq $v0, $k1, _syscall11 #jump to syscall 11
    addi $k1, $0, 12
    beq $v0, $k1, _syscall12 #jump to syscall 12
    #Error state - this should never happen - treat it like an end program
    j _syscall10

#Do init stuff
_syscall0:
    # Initialization goes here
    lui $sp, 1023
    ori $sp, $sp, 0000
    la $k1, _END_OF_STATIC_MEMORY_

    lui $v0, 1023
    sw $k1, 0($v0)

    j _syscallEnd_

#Print Integer
_syscall1:
    # Print Integer code goes here
    addi $v0, $0, 0
    addi $sp, $sp, -12
    sw $t0, 0($sp)
    sw $t1, 4($sp)
    sw $t2, 8($sp)

    addi $t2, $0, 0
    addi $t0, $a0, 0

    bne $t0, $0, syscall1loop
    addi $t0, $t0, 48
    sw $t0, -4096($0)
    j syscall1finish

syscall1loop:
    beq $t0, $0, syscall1print
    addi $t1, $0, 10
    div $t0, $t1
    addi $t2, $t2, 1
    mflo $t0
    mfhi $t1
    addi $sp, $sp, -4
    sw $t1, 0($sp)
    j syscall1loop

syscall1print:
    beq $t2, $0, syscall1finish
    addi $t2, $t2, -1
    lw $t0, 0($sp)
    addi $sp, $sp, 4
    addi $t0, $t0, 48
    sw $t0, -4096($0)
    j syscall1print

syscall1finish:
    lw $t0, 0($sp)
    lw $t1, 4($sp)
    lw $t2, 8($sp)
    addi $sp, $sp, 12

    jr $k0

#Read Integer
_syscall5:
    # Read Integer code goes here
    addi $v0, $0, 0
    addi $sp, $sp, -12
    sw $t0, 0($sp)
    sw $t1, 4($sp)
    sw $t2, 8($sp)

    j syscall5loop

syscall5finish:
    sw $0, -4080($0)
    lw $t0, 0($sp)
    lw $t1, 4($sp)
    lw $t2, 8($sp)
    addi $sp, $sp, 12
    jr $k0

syscall5loop:
    lw $t0, -4080($0)
    beq $t0, 0, syscall5finish
    lw $t0, -4076($0)
    addi $t1, $0, 48
    slt $t2, $t0, $t1
    bne $t2, $0, syscall5finish
    addi $t1, $0, 57
    slt $t2, $t1, $t0
    bne $t2, $0, syscall5finish
    sw $0, -4080($0)
    addi $t0, $t0, -48
    sll $t1, $v0, 3
    sll $t2, $v0, 1
    add $v0, $t1, $t2
    add $v0, $v0, $t0
    j syscall5loop

#Heap allocation
_syscall9:
    # Heap allocation code goes here
    lui $k1, 1023
    lw $v0, 0($k1)
    add $k1, $v0, $a0
    lui $t0, 1023
    sw $k1, 0($t0)
    jr $k0

#"End" the program
_syscall10:
    j _syscall10

#print character
_syscall11:
    # print character code goes here
    sw $a0, -4096($0)
    jr $k0

#read character
_syscall12:
    # read character code goes here
    lw $v0, -4080($0)
    beq $v0, $0, _syscall12
    lw $v0, -4076($0)
    sw $0, -4080($0)
    jr $k0

#extra credit syscalls go here?

_syscallEnd_: