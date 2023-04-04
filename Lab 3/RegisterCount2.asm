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
        addi $sp, $sp, -32
        sw $s0, 0($sp)
        sw $s1, 4($sp)
        sw $s2, 8($sp)
        sw $s3, 12($sp)
        sw $s4, 16($sp)
        sw $s5, 20($sp)
        sw $s6, 24($sp)
        sw $ra, 28($sp)

        move $s0, $zero # Initialize count to 0
        move $s1, $a0 # Copy register to be counted

        la $s2, loop # Load loop address

    loop:
        la $s3, end_loop # Load end_loop address
        bgt $s2, $s3, finish # Check if we reached the end of the loop

        lw $s4, 0($s2) # Load instruction from memory

        andi $s5, $s4, 0xFC000000
        beq $s5, $zero, r_type
        srl $s5, $s5, 26
        beq $s5, 2, Increment
        beq $s5, 3, Increment
        j i_type

    i_type:
        andi $s6, $s4, 0x03E00000
        srl $s6, $s6, 21
        bne $s6, $s1, i_type_rt
        addi $s0, $s0, 1

    i_type_rt:
        andi $s6, $s4, 0x001F0000
        srl $s6, $s6, 16
        bne $s6, $s1, Increment
        addi $s0, $s0, 1
        j Increment

    r_type:
        andi $s6, $s4, 0x03E00000
        srl $s6, $s6, 21
        bne $s6, $s1, r_type_rt
        addi $s0, $s0, 1

    r_type_rt:
        andi $s6, $s4, 0x001F0000
        srl $s6, $s6, 16
        bne $s6, $s1, r_type_rd
        addi $s0, $s0, 1

    r_type_rd:
        andi $s6, $s4, 0x0000F800
        srl $s6, $s6, 11
        bne $s6, $s1, Increment
        addi $s0, $s0, 1

    Increment:
        addi $s2, $s2, 4
        j loop

    finish:
        move $v0, $s0

        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $s3, 12($sp)
        lw $s4, 16($sp)
        lw $s5, 20($sp)
        lw $s6, 24($sp)
        lw $ra, 28($sp)
        addi $sp, $sp, 32
        jr $ra

    end_loop: