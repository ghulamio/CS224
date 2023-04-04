# CS224
# Recitation No 3
# Section No 3
# Ghulam Ahmed
# 22101001
# 27 / 3 / 2023

.data
    p1: .asciiz "\nEnter the size of the linked list: "
    p2: .asciiz "Enter the node value: "
    p4: .asciiz "\nThe original linked list is: "
    p5: .asciiz "\n\n\nThe linked list after deletion is: "
    line: .asciiz "\n --------------------------------------"
    nodeNumberLabel: .asciiz	"\n Node No.: "
    dataValueOfCurrentNode: .asciiz	"\n Data Value of Current Node: "

.text
    main:
        li $v0, 4
        la $a0, p1
        syscall

        li $v0, 5
        syscall
        move $a0, $v0
        jal createLinkedList
        move $s0, $v0

        # Print the linked list
        li $v0, 4
        la $a0, p4
        syscall
        move $a0, $s0
        jal printLinkedList

        # Delete the repeated values
        move $a0, $s0
        jal deleteRepeatedValues
        move $s0, $v0 

        # Print the updated linked list
        li $v0, 4
        la $a0, p5
        syscall
        move $a0, $s0
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

    createLinkedList:
        # $a0: No. of nodes to be created ($a0 >= 1)
        # $v0: returns list head
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


    deleteRepeatedValues:
        addi $sp, $sp, -28
        sw   $s0, 24($sp)
        sw   $s1, 20($sp)
        sw   $s2, 16($sp)
        sw   $s3, 12($sp)
        sw   $s4, 8($sp)
        sw   $s5, 4($sp)
        sw   $ra, 0($sp)

        move $s0, $a0 # $s0: points to the linked list.
        move $s1, $a0 # $s1: points to the current node.

    deleteRepeatedValuesLoop:
        lw   $s4, 0($s1) # $s4: points to the next node.
        beq  $s4, $zero, deleteRepeatedValuesDone # check if next node is null
        lw   $s2, 4($s1) # $s2: Data of current node
        lw   $s3, 4($s4) # $s3: Data of next node
        bne  $s2, $s3, updateCurrentNode # if data is not equal, update current node

        # At this point, data of the current and next nodes are equal
    deleteRepeatedValuesLoop2:
        lw   $s5, 0($s4) # $s5: points to the next node.
        beq  $s5, $zero, deleteRepeatedValuesLastNode # check if next node is null
        lw   $t0, 4($s5) # $t0: Data of next node
        bne  $s2, $t0, updateNextNode # if data is not equal, update next node
        move $s4, $s5
        j    deleteRepeatedValuesLoop2

    updateNextNode:
        sw   $s5, 0($s1) # $s1: points to the current node.
        j    deleteRepeatedValuesLoop

    updateCurrentNode:
        move $s1, $s4
        j    deleteRepeatedValuesLoop

    deleteRepeatedValuesLastNode:
        sw   $zero, 0($s1) # set previous node's next pointer to null

    deleteRepeatedValuesDone:
        move $v0, $s0 # $v0: points to the linked list.
        lw   $ra, 0($sp)
        lw   $s5, 4($sp)
        lw   $s4, 8($sp)
        lw   $s3, 12($sp)
        lw   $s2, 16($sp)
        lw   $s1, 20($sp)
        lw   $s0, 24($sp)
        addi $sp, $sp, 28
        jr   $ra

    