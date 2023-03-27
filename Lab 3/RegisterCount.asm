# CS224
# Recitation No 3
# Section No 3
# Ghulam Ahmed
# 22101001
# 27 / 3 / 2023

.data
    p1 : .asciiz "Enter register to be counted: "
    p2 : .asciiz "Register count in subprogram: "
    newline: .asciiz "\n"

.text
    main:
        li  $v0, 4
        la  $a0, p1
        syscall
        li  $v0, 5
        syscall

        # Validate input
        bgt $v0, 31, end
        blt $v0, 1, end

        move $a0, $v0 
        jal get_register_count
        move $s0, $v0

        li  $v0, 4
        la  $a0, p2
        syscall
        move $a0, $s0
        li  $v0, 1
        syscall
        li $v0, 4
        la $a0, newline
        syscall
        
        j main

    end:
        li $v0, 10
        syscall



get_register_count:
    addi $sp, $sp, -24
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $ra, 20($sp)

    move $s0, $zero # Initialize count to 0
    move $s1, $a0 # Copy register to be counted

    la $s2, loop # Load loop address

loop:
    la $t0, end_loop # Load end_loop address
    bgt $s2, $t0, finish # Check if we reached the end of the loop

    lw $t1, 0($s2) # Load instruction from memory

    andi $t2, $t1, 0xFC000000
    beq $t2, $zero, r_type
    srl $t2, $t2, 26
    beq $t2, 2, Increment
    beq $t2, 3, Increment
    j i_type

i_type:
    andi $t3, $t1, 0x03E00000
    srl $t3, $t3, 21
    bne $t3, $s1, i_type_rt
    addi $s0, $s0, 1

i_type_rt:
    andi $t3, $t1, 0x001F0000
    srl $t3, $t3, 16
    bne $t3, $s1, Increment
    addi $s0, $s0, 1
    j Increment

r_type:
    andi $t3, $t1, 0x03E00000
    srl $t3, $t3, 21
    bne $t3, $s1, r_type_rt
    addi $s0, $s0, 1

r_type_rt:
    andi $t3, $t1, 0x001F0000
    srl $t3, $t3, 16
    bne $t3, $s1, r_type_rd
    addi $s0, $s0, 1

r_type_rd:
    andi $t3, $t1, 0x0000F800
    srl $t3, $t3, 11
    bne $t3, $s1, Increment
    addi $s0, $s0, 1

Increment:
    addi $s2, $s2, 4
    j loop

finish:
    move $v0, $s0

    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $ra, 20($sp)
    addi $sp, $sp, 24
    jr $ra

end_loop: