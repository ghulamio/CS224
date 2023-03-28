# You are not allowed to use $t registers in the subprograms.  
# When you enter a subprogram save $s registers you use in the subprogram to the stack. When necessary save $ra register too.
# Write a recursive subprogram to print the contents of a linked list in reverse order.
# For example, <8, 7, 3, 15> is printed as 15, 3, 7, 8.

.data
    p1:	.asciiz "Enter the number of nodes to be created: "
    p2: .asciiz "The linked list in original order is: "
    p3: .asciiz "The linked list in reverse order is: "
    line:	
        .asciiz "\n --------------------------------------"
    nodeNumberLabel:
        .asciiz	"\n Node No.: "
    addressOfCurrentNodeLabel:
        .asciiz	"\n Address of Current Node: "
    addressOfNextNodeLabel:
        .asciiz	"\n Address of Next Node: "
    dataValueOfCurrentNode:
        .asciiz	"\n Data Value of Current Node: "
    space: .asciiz " "
    
.text
    main:
        li	$v0, 4
        la	$a0, p1
        syscall
        li	$v0, 5
        syscall
        move	$a0, $v0
        jal	createLinkedList
        move	$a0, $v0

        # Print the linked list in original order.
        la	$a0, p2
        li	$v0, 4
        syscall
        move	$a0, $v0
        jal	printLinkedList

        # # Print the linked list in reverse order.
        # la	$a0, p3
        # li	$v0, 4
        # syscall
        # move	$a0, $v0
        # jal	printReverseLinkedList

        li     $v0, 10
        syscall

    createLinkedList:
    # $a0: No. of nodes to be created ($a0 >= 1)
    # $v0: returns list head
    # Node 1 contains 4 in the data field, node i contains the value 4*i in the data field.
        addi	$sp, $sp, -24
        sw	$s0, 20($sp)
        sw	$s1, 16($sp)
        sw	$s2, 12($sp)
        sw	$s3, 8($sp)
        sw	$s4, 4($sp)
        sw	$ra, 0($sp) 	
        
        move	$s0, $a0	# $s0: no. of nodes to be created.
        li	$s1, 1		# $s1: Node counter

        # Create the first node: header.
        li	$a0, 8 # Each node is 8 bytes: link field then data field.
        li	$v0, 9
        syscall

        # OK now we have the list head. Save list head pointer 
        move	$s2, $v0	# $s2 points to the first and last node of the linked list.
        move	$s3, $v0	# $s3 now points to the list head.
        sll	$s4, $s1, 2	# sll: So that node 1 data value will be 4, node i data value will be 4*i
        sw	$s4, 4($s2)	# Store the data value.
        
    addNode:
        beq	$s1, $s0, allDone
        addi	$s1, $s1, 1	# Increment node counter.
        li	$a0, 8 		# Remember: Node size is 8 bytes.
        li	$v0, 9
        syscall
        
        sw	$v0, 0($s2) # Connect the this node to the lst node pointed by $s2.
        move	$s2, $v0 # $s2 now points to the new node.
        sll	$s4, $s1, 2	# sll: So that node 1 data value will be 4, node i data value will be 4*i
        sw	$s4, 4($s2)	# Store the data value.
        j	addNode

    allDone:
    # Make sure that the link field of the last node cotains 0.
        sw	$zero, 0($s2) # The last node is pointed by $s2.
        move	$v0, $s3	# Now $v0 points to the list head ($s3).
        
    # Restore the register values
        lw	$ra, 0($sp)
        lw	$s4, 4($sp)
        lw	$s3, 8($sp)
        lw	$s2, 12($sp)
        lw	$s1, 16($sp)
        lw	$s0, 20($sp)
        addi	$sp, $sp, 24
        
        jr	$ra

    printLinkedList:
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
        beq	$s0, $zero, printedAll # $s0: Address of current node
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
        move	$s0, $s1	# Consider next node.
        j	printNextNode

    printedAll:
        lw	$ra, 0($sp)
        lw	$s3, 4($sp)
        lw	$s2, 8($sp)
        lw	$s1, 12($sp)
        lw	$s0, 16($sp)
        addi	$sp, $sp, 20
        jr	$ra

    printReverseLinkedList:
        addi   $sp, $sp, -20
        sw	$s0, 16($sp)
        sw	$s1, 12($sp)
        sw     $s2, 8($sp)
        sw     $s3, 4($sp)
        sw     $ra, 0($sp) 	

        move  $s0, $a0	# $s0: points to the list head.
        la   $a0, line
        li   $v0, 4
        syscall		# Print line seperator
        la   $a0, p3
        li   $v0, 4
        syscall

        traverseLinkedList:
            beq	$s0, $zero, traverseDone # $s0: Address of current node
            lw   $s1, 0($s0)	# $s1: Address of  next node
            jal printNode
            move $s0, $s1	# Consider next node.
            j traverseLinkedList
        
        traverseDone:
            lw	$ra, 0($sp)
            lw	$s3, 4($sp)
            lw	$s2, 8($sp)
            lw	$s1, 12($sp)
            lw	$s0, 16($sp)
            addi	$sp, $sp, 20
            jr	$ra

        printNode:
            lw $v1, 4($s0)	# $v1: Data of current node
            move $a0, $v1	# $v1: Data of current node
            li $v0, 1
            syscall
            li $v0, 4
            la $a0, space
            syscall
            jr $ra