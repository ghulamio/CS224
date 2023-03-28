	.text
main:
	
	li	$v0, 4
	la	$a0, inputLinkedListSizePrompt
	syscall
	li	$v0, 5
	syscall
	
	move	$s0, $v0 # $s0 contains the size of the linkedlist to form

	move	$a0, $s0
	jal	initLinkedList
	move	$s1, $v0 # s1 points to the head of the linkedlist
	
	li	$v0, 4
	la	$a0, originalListPrompt
	syscall
	move	$a0, $s1
	jal	printLinkedList
	
	li	$v0, 4
	la	$a0, printReversePrompt
	syscall
	
	li	$v0, 11
	li	$a0, '<'
	syscall
	lw	$s2, 0($s1)
	move	$a0, $s2
	jal	PrintReverseOrder	
	li	$v0, 11
	li	$a0, '>'
	syscall
	li	$a0, '\n'
	syscall	
	
	# end program
	li	$v0, 10
	syscall
	
# ****** Function initialize LinkedList ******
# params[in]: $a0 = size of Linkedlist
# returns: $v0 = root address of the LinkedList	
initLinkedList:
	addi	$sp, $sp, -24
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	sw	$ra, 20($sp)
	
	move	$s0, $a0
	li	$s1, 0
	
	# Each node is 8 bytes: link field then data field
	# Create the fist node: header
	li	$a0, 8
	li	$v0, 9
	syscall
	
	move	$s2, $v0  # s2 points to the first and last node of LinkedList
	move	$s3, $v0  # s3 points to the list head
	
	addNode:
	beq	$s1, $s0, allDone
	li	$a0, 8
	li	$v0, 9
	syscall
	sw	$v0, 0($s2)
	move	$s2, $v0
	li	$v0, 4
	la	$a0, enterElementForIndexPrompt
	syscall
	li	$v0, 1
	move	$a0, $s1
	syscall
	#### Print colon and then space
	li	$v0, 11
	li	$a0, ':'
	syscall
	li	$a0, ' '
	syscall
	####
	li	$v0, 5
	syscall
	sw	$v0, 4($s2)
	addi	$s1, $s1, 1 
	j	addNode
	
	allDone:
	sw	$zero, 0($s2)
	move	$v0, $s3	# v0 now points to the list head $s3
	
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jr	$ra

#***** Function printLinkedList
# params[in]: $a0 = head of linkedlist
printLinkedList:
	addi	$sp, $sp, -20
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$ra, 16($sp)
	
	lw	$s0, 0($a0)
	li	$s3, 0
	
	li	$v0, 11
	li	$a0, '<'
	syscall
	printNextNode:
	beq	$s0, $zero, printedAll
	
	lw	$s1, 0($s0) # Address of next node
	lw	$s2, 4($s0) # Data of current node
	
	li	$v0, 1
	move	$a0, $s2
	syscall
	li	$v0, 11
	li	$a0, ','
	syscall	
	move	$s0, $s1 # consider next node	
	j	printNextNode
	
	printedAll:
	li	$v0, 11
	li	$a0, '>'
	syscall
	li	$a0, '\n'
	syscall
	
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$ra, 16($sp)
	jr	$ra

# ****** Function PrintReverse ******
# params[in]: $a0 = head of the linkedList
# return: NaN
PrintReverseOrder:
	addi	$sp, $sp, -8
	sw	$a0, 0($sp)
	sw	$ra, 4($sp)
	
	bne	$a0, $zero, recurse
	lw	$a0, 0($sp)
	lw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jr	$ra 
	recurse:
	lw	$a0, 0($a0)
	jal	PrintReverseOrder
	lw	$a0, 0($sp)
	li	$v0, 1
	lw	$a0, 4($a0)
	syscall	
	li	$v0, 11
	li	$a0, ','
	syscall
	
	end:
	lw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jr	$ra
	
	.data
inputLinkedListSizePrompt:
	.asciiz "Enter size of the original linked list: " 
originalListPrompt:
	.asciiz "Original: "
enterElementForIndexPrompt:
	.asciiz "Enter the element for element at index "
printReversePrompt:
	.asciiz "Printed In Reverse: "
	