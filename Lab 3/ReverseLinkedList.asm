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
	
	move	$a0, $s1
	jal	ReverseLinkedList
	move	$s1, $a0 # save $s1 to the value of $a0
	
	li	$v0, 4
	la	$a0, reversedListPrompt
	syscall
	move	$a0, $s1
	jal	printLinkedList
	
	#end program
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
	
# ****** Function Reverse Linked List ******
# params[in]: $a0 = head of linkedlist (sets by ref)
ReverseLinkedList:
	addi	$sp, $sp, -8
	sw	$a0, 0($sp)
	sw	$ra, 4($sp)
	
	
	lw	$a0, 0($a0) # take the first node (root.next)
	move	$s0, $a0 # store address copy of the first node
	addi	$a1, $zero, 0 # set prev node
	addi	$a2, $zero , 0 # set new first node
	jal	ReverseLinkedListHelper
	
	sw	$zero, 0($s0) # set to null the previous first node's next		
	lw	$a0, 0($sp) # pop root address from stack
	sw	$a2, 0($a0) # set the first node (root.next= $a2)
	
	lw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jr	$ra

# ****** Function Reverse Linked List Helper Function ******
# brief: Implements the recursive reversal
# params: $a0 = current node, $a1 = prev node, $a2 = head of reversed (passed by ref)
ReverseLinkedListHelper:
	addi	$sp, $sp, -12
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	sw	$ra, 8($sp)
	
	bne	$a0, $zero, recurse
	move	$a2, $a1 # set the head of the reversed linked list
	lw	$a0, 0($sp)
	lw	$a1, 4($sp)
	lw	$ra, 8($sp)
	addi	$sp, $sp, 12
	jr	$ra
	recurse:
	move	$a1, $a0 # set prev ptr to current ptr
	lw	$a0, 0($a0) # current ptr = current ptr.next
	jal	ReverseLinkedListHelper
	lw	$a0, 0($sp)
	lw	$a1, 4($sp)
	
	sw	$a1, 0($a0)
	lw	$ra, 8($sp)
	addi	$sp, $sp, 12
	jr	$ra
	
	
	
	
	
	.data
inputLinkedListSizePrompt:
	.asciiz "\nEnter size of the original linked list: " 
originalListPrompt:
	.asciiz "Original: "
enterElementForIndexPrompt:
	.asciiz "Enter the element for element at index "
reversedListPrompt:
	.asciiz "After in-place reversal: "
	
	