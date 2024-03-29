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

        move $s0, $zero # $s0: register count
        move $s1, $a0 # $s1: register to be counted

        la $s2, loop # $s2: loop start address

    loop:
        la $s3, end_loop # $s3: loop end address
        bgt $s2, $s3, finish  

        lw $s4, ($s2) # $s4: current address content
        beq $s4, $s1, inc_count 
        addi $s2, $s2, 4 # increment loop address
        j loop
    inc_count:
        addi $s0, $s0, 1
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