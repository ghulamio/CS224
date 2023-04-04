# CS224
# Recitation No 3
# Section No 3
# Ghulam Ahmed
# 22101001
# 27 / 3 / 2023 

.data
	p1: .asciiz "\nEnter size of the linked list: " 
	p3: .asciiz "\nThe linked list is: "
	p4: .asciiz "\n\nThe linked list in reverse order is: \n"
    p2: .asciiz "Enter the node value: "
    line: .asciiz "\n --------------------------------------"
	comma: .asciiz ", "
    nodeNumberLabel: .asciiz	"\n Node No.: "
    dataValueOfCurrentNode: .asciiz	"\n Data Value of Current Node: "

.text
	main:
		li	$v0, 4
		la	$a0, p1
		syscall
		li	$v0, 5
		syscall
		move $s0, $v0 # $s0: No. of nodes to be created.

		move $a0, $s0
		jal createLinkedList
		move $s1, $v0 # $s1: points to the list head.
		
		li	$v0, 4
		la	$a0, p3
		syscall
		move $a0, $s1
		jal	printLinkedList
		
		li	$v0, 4
		la	$a0, p4
		syscall
		move $a0, $s1
		jal	printLinkedListReverse

		li	$v0, 10
		syscall

	createLinkedList:
        addi	$sp, $sp, -24
        sw	$s0, 20($sp)
        sw	$s1, 16($sp)
        sw	$s2, 12($sp)
        sw	$s3, 8($sp)
        sw	$s4, 4($sp)
        sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram
        
        move	$s0, $a0	# $s0: no. of nodes to be created.
        li	$s1, 1		# $s1: Node counter
        # Create the first node: header.
        # Each node is 8 bytes: link field then data field.
        li	$a0, 8
        li	$v0, 9
        syscall
        move	$s2, $v0	# $s2 points to the first and last node of the linked list.
        move	$s3, $v0	# $s3 now points to the list head.
        # sll	$s4, $s1, 2	# sll: So that node 1 data value will be 4, node i data value will be 4*i
        # Ask user to enter the data value of the first node.
        li $v0, 4
        la $a0, p2
        syscall
        li	$v0, 5
        syscall
        move	$s4, $v0	# $s4: data value of the first node.
        sw	$s4, 4($s2)	# Store the data value.
        
    addNode:
        beq	$s1, $s0, allDone
        addi	$s1, $s1, 1	# Increment node counter.
        li	$a0, 8 		# Remember: Node size is 8 bytes.
        li	$v0, 9
        syscall
        # Connect the this node to the lst node pointed by $s2.
        sw	$v0, 0($s2)
        # Now make $s2 pointing to the newly created node.
        move	$s2, $v0	# $s2 now points to the new node.
        # sll	$s4, $s1, 2	# sll: So that node 1 data value will be 4, node i data value will be 4*i
        # Ask user to enter the data value of the first node.
        li $v0, 4
        la $a0, p2
        syscall
        li	$v0, 5
        syscall
        move	$s4, $v0	# $s4: data value of the first node.
        sw	$s4, 4($s2)	# Store the data value.
        j	addNode
    allDone:
        # Make sure that the link field of the last node cotains 0.
        # The last node is pointed by $s2.
        sw	$zero, 0($s2)
        move	$v0, $s3	# Now $v0 points to the list head ($s3).
        
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
        lw	$ra, 0($sp)
        lw	$s3, 4($sp)
        lw	$s2, 8($sp)
        lw	$s1, 12($sp)
        lw	$s0, 16($sp)
        addi	$sp, $sp, 20
        jr	$ra

	printLinkedListReverse:
		addi	$sp, $sp, -20
		sw	$s0, 16($sp)
		sw	$s1, 12($sp)
		sw	$s2, 8($sp)
		sw	$s3, 4($sp)
		sw	$ra, 0($sp)	

        move	$s1, $zero
        move	$s0, $a0	# $s0: points to the list head.

    printLinkedListReverseLoop:
        beq	$s0, $zero, printLinkedListReverseDone # $s0: Address of current node
        lw	$s2, 0($s0)	# $s2: Address of  next node
        move	$s3, $s0
        move	$s0, $s2	# Consider next node.
        j	printLinkedListReverseLoop

    printLinkedListReverseDone:
        move	$s0, $s3
        move	$a0, $s0
        jal	printNode
        move	$s0, $s3
        move	$a0, $s0
        jal	printLinkedListReverse
	
	printNode:
		beq	$s0, $zero, printNodeDone # $s0: Address of current node
		lw	$s1, 0($s0)	# $s1: Address of  next node
		lw	$s2, 4($s0)	# $s2: Data of current node
		la	$a0, line
		li	$v0, 4
		syscall		

		la	$a0, nodeNumberLabel
		li	$v0, 4
		syscall
		move	$a0, $s3	# $s3: Node number (position) of current node
		li	$v0, 1
		syscall
		
		la	$a0, dataValueOfCurrentNode
		li	$v0, 4
		syscall
		move	$a0, $s2	# $s2: Data of current node
		li	$v0, 1		
		syscall	
		
		la	$a0, comma
		li	$v0, 4
		syscall
	
	printNodeDone:
		lw	$ra, 0($sp)
		lw	$s3, 4($sp)
		lw	$s2, 8($sp)
		lw	$s1, 12($sp)
		lw	$s0, 16($sp)
		addi	$sp, $sp, 20
		jr	$ra