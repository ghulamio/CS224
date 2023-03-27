# CS224
# Recitation No 3
# Section No 3
# Ghulam Ahmed
# 22101001
# 27 / 3 / 2023

.data
    p1: .asciiz "Enter the dividend: "
    p2: .asciiz "Enter the divisor: "
    p3: .asciiz "Quotient: "
    p4: .asciiz "Remainder: "
    newline: .asciiz "\n"

.text:
    main:
        li $v0, 4
        la $a0, p1
        syscall
        li $v0, 5
        syscall
        move $s0, $v0 # s0: dividend
        
        li $v0, 4
        la $a0, p2
        syscall
        li $v0, 5 
        syscall #v0: divisor
        
        move $a0, $s0 
        move $a1, $v0 
        move $a2, $0
        jal recursive_division
        move $s0, $v0
        move $s1, $v1
        
        li $v0, 4
        la $a0, p3
        syscall
        li $v0, 1
        move $a0, $s0
        syscall
        li $v0, 4
        la $a0, newline
        syscall
        
        li $v0, 4
        la $a0, p4
        syscall
        li $v0, 1
        move $a0, $s1
        syscall
        li $v0, 4
        la $a0, newline
        syscall
        
        li $v0, 10
        syscall

    recursive_division:
        addi $sp, $sp, -4
        sw $ra, 0($sp)
        
        bgt $a0, $a1, subtract
        beq $a0, $a1, subtract
        # if dividend < divisor, return quotient and remainder
        move $v1, $a0 
        addi $sp, $sp, 4
        jr $ra        
        
        subtract:
        sub $a0, $a0, $a1
        addi $a2, $a2, 1
        jal recursive_division
        move $v0, $a2    
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra