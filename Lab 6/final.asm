.text

main:
    jal inputDimension
    move $s0, $v0

    li $v0, 4
    la $a0, printDimensionSelected
    syscall
    li $v0, 1
    move $a0, $s0
    syscall
    li $v0, 11
    li $a0, '\n'
    syscall

    move $a0, $s0
    jal createMatrix
    move $s1, $v0
    move $s2, $v1

    beginMenu:
    li $v0, 4
    la $a0, MenuPrompt
    syscall
    li $v0, 5
    syscall
    move $s3, $v0
    beq $s3, 4, end
    beq $s3, 2, colMajor
    beq $s3, 3, desiredElement

    rowMajor:
    li $v0, 4
    la $a0, input_row_prompt
    syscall
    li $v0, 5
    syscall
    move $a0, $v0
    move $a1, $s0
    move $a2, $s2
    jal getRowSum
    move $s3, $v0
    li $v0, 4
    la $a0, output_row_sum
    syscall
    li $v0, 1
    move $a0, $s3
    syscall
    li $v0, 11
    li $a0, '\n'
    syscall
    j next

    colMajor:
    li $v0, 4
    la $a0, input_col_prompt
    syscall
    li $v0, 5
    syscall
    move $a0, $v0
    move $a1, $s0
    move $a2, $s2
    jal getColSum
    move $s3, $v0
    li $v0, 4
    la $a0, output_col_sum
    syscall
    li $v0, 1
    move $a0, $s3
    syscall
    li $v0, 11
    li $a0, '\n'
    syscall
    j next

    desiredElement:
    li $v0, 4
    la $a0, input_i_prompt
    syscall
    li $v0, 5
    syscall
    move $s3, $v0
    li $v0, 4
    la $a0, input_j_prompt
    syscall
    li $v0, 5
    syscall
    move $s4, $v0

    move $a0, $s3
    move $a1, $s4
    move $a2, $s0
    move $a3, $s2
    jal getDesiredElement
    move $s5, $v0
    li $v0, 4
    la $a0, output_element_prompt
    syscall
    move $a0, $s5
    li $v0, 1
    syscall
    li $v0, 11
    li $a0, '\n'
    syscall

    next:
    j beginMenu

end:
    li $v0, 10
    syscall


inputDimension:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    li $v0, 4
    la $a0, inputDimensionPrompt
    syscall
    li $v0, 5
    syscall
    move $v0, $a0
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    jr $ra


createMatrix:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    move $s0, $a0

    sll $s1, $a0, 2
    addi $v0, $s1, 0
    li $v1, 9
    syscall

    move $v0, $s1
    move $v1, $v0
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra


initMatrix:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    move $s0, $a0
    move $s1, $a1
    li $t0, 0

    loop:
    beq $s0, $t0, end_init
    sll $t1, $t0, 2
    add $t2, $s1, $t1
    sw $zero, 0($t2)
    addi $t0, $t0, 1
    j loop

    end_init:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra


getRowSum:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    move $s0, $a0
    move $s1, $a2
    li $t0, 0
    li $t1, 0

    loop:
    beq $t0, $s0, end_row_sum
    sll $t2, $t0, 2
    add $t3, $s1, $t2
    lw $t4, 0($t3)
    add $t1, $t1, $t4
    addi $t0, $t0, 1
    j loop

    end_row_sum:
    move $v0, $t1
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 8
    jr $ra


getColSum:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    move $s0, $a0
    move $s1, $a2
    li $t0, 0
    li $t1, 0

    loop:
    beq $t0, $s0, end_col_sum
    sll $t2, $t0, 2
    add $t3, $s1, $t2
    lw $t4, 0($t3)
    add $t1, $t1, $t4
    addi $t0, $t0, 1
    j loop

    end_col_sum:
    move $v0, $t1
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 8
    jr $ra


getDesiredElement:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    move $s0, $a0
    move $s1, $a1
    move $s2, $a3
    li $t0, 0
    li $t1, 0

    loop:
    beq $t0, $s0, end_desired_element
    sll $t2, $t0, 2
    add $t3, $s1, $t2
    lw $t4, 0($t3)
    beq $t0, $s2, found_element
    addi $t0, $t0, 1
    j loop

    found_element:
    move $v0, $t4
    j end_desired_element

    end_desired_element:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    addi $sp, $sp, 12
    jr $ra

.data
Prompt1: .asciiz "Enter the dimension of the matrix: "
Prompt2: .asciiz "Dimension: "
Prompt3: .asciiz "i: "
Prompt4: .asciiz "j: "
Prompt5: .asciiz "element: "
Prompt6: .asciiz "row number: "
Prompt7: .asciiz "row sum: "
Prompt8: .asciiz "column number: "
Prompt9: .asciiz "column sum: