# You are not allowed to use $t registers in the subprograms.  
# When you enter a subprogram save $s registers you use in the subprogram to the stack. When necessary save $ra register too.

# Write a subprogram to delete multiple values from a sorted linked list. 
# For example, after executing this subprogram <1, 2, 2, 5, 5, 5, 7> becomes <1, 2, 5, 7>

.data
    p1: .asciiz "Enter the size of the linked list: "
    p2: .asciiz "Enter the node value: "
    p3: .asciiz "Enter the value to be deleted: "
    p4: .asciiz "The linked list before deletion is: "
    p5: .asciiz "The linked list after deletion is: "
    line: .asciiz "\n --------------------------------------"
    nodeNumberLabel: .asciiz	"\n Node No.: "
    addressOfCurrentNodeLabel: .asciiz	"\n Address of Current Node: "
    addressOfNextNodeLabel: .asciiz	"\n Address of Next Node: "
    dataValueOfCurrentNode: .asciiz	"\n Data Value of Current Node: "


.text
    main:
        jal initLinkedList
        move $a0, $v0
        move $s0, $v0
        jal printLinkedList

        li $v0, 10
        syscall

    printLinkedList:
    # Save $s registers used
        addi	$sp, $sp, -20
        sw	$s0, 16($sp)
        sw	$s1, 12($sp)
        sw	$s2, 8($sp)
        sw	$s3, 4($sp)
        sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram

    # $a0: points to the linked list.
    # $s0: Address of current
    # s1: Address of next
    # $2: Data of current
    # $s3: Node counter: 1, 2, ...
        move $s0, $a0	# $s0: points to the current node.
        li   $s3, 0
    printNextNode:
        beq	$s0, $zero, printedAll
                    # $s0: Address of current node
        lw	$s1, 0($s0)	# $s1: Address of  next node
        lw	$s2, 4($s0)	# $s2: Data of current node
        addi	$s3, $s3, 1
    # $s0: address of current node: print in hex.
    # $s1: address of next node: print in hex.
    # $s2: data field value of current node: print in decimal.
        la	$a0, line
        li	$v0, 4
        syscall		# Print line seperator
        
        la	$a0, nodeNumberLabel
        li	$v0, 4
        syscall
        
        move	$a0, $s3	# $s3: Node number (position) of current node
        li	$v0, 1
        syscall
        
        la	$a0, addressOfCurrentNodeLabel
        li	$v0, 4
        syscall
        
        move	$a0, $s0	# $s0: Address of current node
        li	$v0, 34
        syscall

        la	$a0, addressOfNextNodeLabel
        li	$v0, 4
        syscall
        move	$a0, $s1	# $s0: Address of next node
        li	$v0, 34
        syscall	
        
        la	$a0, dataValueOfCurrentNode
        li	$v0, 4
        syscall
            
        move	$a0, $s2	# $s2: Data of current node
        li	$v0, 1		
        syscall	

    # Now consider next node.
        move	$s0, $s1	# Consider next node.
        j	printNextNode
    printedAll:
    # Restore the register values
        lw	$ra, 0($sp)
        lw	$s3, 4($sp)
        lw	$s2, 8($sp)
        lw	$s1, 12($sp)
        lw	$s0, 16($sp)
        addi	$sp, $sp, 20
        jr	$ra


initLinkedList:
    addi $sp, $sp, -8   # Make space for $s0, $s1, and $ra
    sw $s0, 4($sp)      # Save $s0
    sw $s1, 0($sp)      # Save $s1
    sw $ra, 8($sp)      # Save $ra

    # Initialize the head
    li $s0, 1           # Set the value to 1
    li $s1, 0           # Set the address to null

    # Create node 1
    jal createNode      # Create the node
    move $a0, $v0       # Move the address to $a0

    # Create node 2
    li $s0, 2
    jal createNode
    sw $v0, 0($a0)     # Link node 1 to node 2

    # Create node 3
    li $s0, 2
    jal createNode
    sw $v0, 0($v0)     # Link node 2 to node 3

    # Create node 4
    li $s0, 3
    jal createNode
    sw $v0, 0($v0)     # Link node 3 to node 4

    # Create node 5
    li $s0, 4
    jal createNode
    sw $v0, 0($v0)     # Link node 4 to node 5

    # Create node 6
    li $s0, 4
    jal createNode
    sw $v0, 0($v0)     # Link node 5 to node 6

    # Create node 7
    li $s0, 5
    jal createNode
    sw $v0, 0($v0)     # Link node 6 to node 7

    # Return the address of head
    move $v0, $a0

    lw $s0, 4($sp)      # Restore $s0
    lw $s1, 0($sp)      # Restore $s1
    lw $ra, 8($sp)      # Restore $ra
    addi $sp, $sp, 8   # Restore stack pointer
    jr $ra              # Return

# CreateNode
createNode:
    addi $sp, $sp, -8   # Make space for $s2, $s3, and $ra
    sw $s2, 4($sp)      # Save $s2
    sw $s3, 0($sp)      # Save $s3
    sw $ra, 8($sp)      # Save $ra

    # Allocate memory
    li $s2, 8           # Allocate a word
    li $v0, 9           # Syscall code for sbrk
    syscall             # Allocate memory

    # Initialize the node
    sw $s0, 0($v0)      # Store value to the node
    sw $s1, 4($v0)      # Store address to the node

    lw $s2, 4($sp)      # Restore $s2
    lw $s3, 0($sp)      # Restore $s3
    lw $ra, 8($sp)      # Restore $ra
    addi $sp, $sp, 8   # Restore stack pointer
    jr $ra              # Return