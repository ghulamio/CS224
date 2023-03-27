.data
    p1: .asciiz "Enter a number: "
    p2: .asciiz "Do you want to continue? (y/n): "
    p3: .asciiz "Register 1 has value: "
    p4: .asciiz "Register 2 has value: "
    p5: .asciiz "Hamming distance: "
    r1: .word 0 #Register 1
    r2: .word 0 #Register 2
    had: .word 0 #Hamming Distance
    input: .space 2
    yes: .asciiz "y"
    endl: .asciiz "\n"

.text
main:
    jal mainLoop    
    jal continueCheck

continueCheck:
    # ask user if they want to continue
    li $v0, 4
    la $a0, p2
    syscall

    # Get input
    li $v0, 8
    la $a0, input
    li $a1, 2
    move $s0, $a0
    syscall

    # check if user wants to continue
    beq $s0, $zero, exit
    lb $s1, yes
    lb $s0, 0($s0)
    beq $s0, $s1, mainLoop
    j exit

exit:
    li $v0, 10
    syscall

mainLoop:
    li $v0, 4
    la $a0, endl
    syscall
    li $v0, 4
    la $a0, p1
    syscall
    li $v0, 5
    syscall
    sw $v0, r1

    li $v0, 4
    la $a0, p1
    syscall
    li $v0, 5
    syscall
    sw $v0, r2

    # print register values
    li $v0, 4
    la $a0, p3
    syscall
    li $v0, 34
    lw $a0, r1
    syscall
    li $v0, 4
    la $a0, endl
    syscall

    li $v0, 4
    la $a0, p4
    syscall
    li $v0, 34
    lw $a0, r2
    syscall
    li $v0, 4
    la $a0, endl
    syscall

    # calculate hamming distance
    jal CalculateDistance

    # print hamming distance
    li $v0, 4
    la $a0, p5
    syscall
    li $v0, 1
    lw $a0, had
    syscall
    li $v0, 4
    la $a0, endl
    syscall

    j continueCheck


CalculateDistance:
    # Store register values in stack
    addi  $sp, $sp, -24
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)

    lw $s0, r1
    lw $s1, r2
    xor $s2, $s0, $s1
    li $s3, 0
    li $s4, 0

    # Loop through each bit and count the number of 1s
    loop:
        andi $s4, $s2, 1
        beq $s4, $zero, next
        addi $s3, $s3, 1
    next:
        srl $s2, $s2, 1
        bne $s2, $zero, loop
    
    sw $s3, had

    # Restore stack
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    addi $sp, $sp, 24
    jr $ra

