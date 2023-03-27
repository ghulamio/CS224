.data
    P1: .asciiz "Enter the number of elements in the array: "
    P2: .asciiz "Enter an element: "
    P3: .asciiz "Enter the index position of the array: "
    P4: .asciiz "The number of occurrences of the array element that occurs at that position is "
    endl: .asciiz "\n"

.text
    main:
        # Get the size of the array
        li $v0, 4
        la $a0, P1
        syscall
        li $v0, 5
        syscall
        move $s0, $v0

        # Create the array
        move $a0, $s0
        jal CreateArray
        move $s1, $v0

        # Get the index
        li $v0, 4
        la $a0, P3
        syscall
        li $v0, 5
        syscall
        move $s2, $v0

        # Get the value at the index
        sll $s3, $s2, 2
        add $s3, $s3, $s1
        lw $s4, 0($s3)

        # Get the number of occurrences
        move $a0, $s1 # a0 = array
        move $a1, $s4 # a1 = value
        move $a2, $s0 # a2 = size
        jal ElementsAtIndex
        move $s5, $v0

        # Print the number of occurrences
        li $v0, 4
        la $a0, P4
        syscall
        li $v0, 1
        move $a0, $s5
        syscall
        li $v0, 4
        la $a0, endl
        syscall

        li $v0, 10
        syscall

    CreateArray:
        addi $sp, $sp, -16
        sw $s0, 0($sp)
        sw $s1, 4($sp)
        sw $s2, 8($sp)
        sw $ra, 12($sp)

        move $s0, $a0
        sll $s1, $s0, 2
        li $v0, 9
        move $a0, $s1
        syscall
        move $s2, $v0

        move $a0, $s0
        move $a1, $s2
        jal InitializeArray

        move $v0, $s2

        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $ra, 12($sp)
        addi $sp, $sp, 16
        jr $ra

    InitializeArray:
        addi $sp, $sp, -16
        sw $s0, 0($sp)
        sw $s1, 4($sp)
        sw $s2, 8($sp)
        sw $ra, 12($sp)

        move $s0, $a0
        move $s1, $0
        move $s2, $a1

        InitializeArrayLoop:
            beq $s1, $s0, InitializeArrayEnd
            li $v0, 4
            la $a0, P2
            syscall
            li $v0, 5
            syscall
            sw $v0, 0($s2)
            addi $s1, $s1, 1
            addi $s2, $s2, 4
            j InitializeArrayLoop

        InitializeArrayEnd:
            lw $s0, 0($sp)
            lw $s1, 4($sp)
            lw $s2, 8($sp)
            lw $ra, 12($sp)
            addi $sp, $sp, 16
            jr $ra

    ElementsAtIndex:
        addi $sp, $sp, -16
        sw $s0, 0($sp)
        sw $s1, 4($sp)
        sw $s2, 8($sp)
        sw $ra, 12($sp)

        move $s0, $a0 # s0 = array
        move $s1, $a1 # s1 = value
        move $s2, $a2 # s2 = size

        li $s3, 0 # s3 = counter
        li $s4, 0 # s4 = index

        # Loop through the array and count the number of occurrences of the value
        ElementsAtIndexLoop:
            beq $s4, $s2, ElementsAtIndexEnd
            lw $s5, 0($s0)
            beq $s5, $s1, IncrementCounter
            j ElementsAtIndexIncrement

        IncrementCounter:
            addi $s3, $s3, 1
        ElementsAtIndexIncrement:
            addi $s4, $s4, 1
            addi $s0, $s0, 4
            j ElementsAtIndexLoop

        ElementsAtIndexEnd:
            move $v0, $s3

            lw $s0, 0($sp)
            lw $s1, 4($sp)
            lw $s2, 8($sp)
            lw $ra, 12($sp)
            addi $sp, $sp, 16
            jr $ra