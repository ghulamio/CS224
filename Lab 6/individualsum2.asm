	.text
	
main:
	jal	inputDimension
	move	$s0, $v0
	
	li	$v0, 4
	la	$a0, printDimensionSelected
	syscall
	li	$v0, 1
	move	$a0, $s0
	syscall
	li	$v0, 11
	li	$a0, '\n'
	syscall
	
	move	$a0, $s0
	jal	createMatrix
	move	$s1, $v0 # s1 = size of matrix in bytes
	move	$s2, $v1 # s2 = base address of matrix in heap
	# s0 = N
		 	 
	move	$a0, $s0
	move	$a1, $s1
	move	$a2, $s2
	jal	initMatrix 
	
	
	# begin main menu loop
	beginMenu:
		li	$v0, 4
		la	$a0, MenuPrompt
		syscall
		li	$v0, 5
		syscall
		move	$s3, $v0
		beq	$s3, 4, end
		# switch case s3
		beq	$s3, 2, colMajor
		beq	$s3, 3, desiredElement
		
		rowMajor:
		li	$v0, 4
		la	$a0, input_row_prompt
		syscall
		li	$v0, 5
		syscall
		move	$a0, $v0 # set row number
		move	$a1, $s0 # set N
		move	$a2, $s2 # base address of array
		jal	getRowSum
		move	$s3, $v0
		li	$v0, 4
		la	$a0, output_row_sum
		syscall
		li	$v0, 1
		move	$a0, $s3
		syscall
		li	$v0, 11
		li	$a0, '\n'
		syscall
		j next

		colMajor:
		li	$v0, 4
		la	$a0, input_col_prompt
		syscall
		li	$v0, 5
		syscall
		move	$a0, $v0 # set col number
		move	$a1, $s0 # set N
		move	$a2, $s2 # base address of array
		jal	getColSum
		move	$s3, $v0
		li	$v0, 4
		la	$a0, output_col_sum
		syscall
		li	$v0, 1
		move	$a0, $s3
		syscall
		li	$v0, 11
		li	$a0, '\n'
		syscall
		j next

		desiredElement:
		li	$v0, 4
		la	$a0, input_i_prompt
		syscall
		li	$v0, 5
		syscall
		move	$s3, $v0 # s3 = i
		li	$v0, 4
		la	$a0, input_j_prompt
		syscall
		li	$v0, 5
		syscall		
		move	$s4, $v0 # s4 = j
		
		move	$a0, $s3
		move	$a1, $s4
		move	$a2, $s0
		move	$a3, $s2
		jal	getDesiredElement
		move	$s5, $v0
		li	$v0, 4
		la	$a0, output_element_prompt
		syscall
		move	$a0, $s5
		li	$v0, 1
		syscall
		li	$v0, 11
		li	$a0, '\n'
		syscall
														
		next:
		j beginMenu
		
		
	end:
	#end program
	li	$v0, 10
	syscall
	
		
inputDimension:	
	# save registers on stack
	addi	$sp, $sp, -36
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	sw	$s5, 20($sp)
	sw	$s6, 24($sp)
	sw	$s7, 28($sp)
	sw	$ra, 32($sp)
	
	loop:
	li	$v0, 4
	la	$a0, inputDimensionsPrompt
	syscall
	li	$v0, 5
	syscall
	ble	$v0, $zero, invalid
	j 	valid
	invalid:
	li	$v0, 4
	la	$a0, invalidDimensionError
	syscall
	j loop
	
	valid:
	# pop from stack 
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$s5, 20($sp)
	lw	$s6, 24($sp)
	lw	$s7, 28($sp)
	lw	$ra, 32($sp)
	addi	$sp, $sp, 36
	jr	$ra		
	
#****** subroutine Create Matrix ******
# params[in]: $a0 = dimension of the matrix
# returns: $v0 = size of matrix in bytes, $v1 = base address of the matrix in heap	
createMatrix:
	# save registers on stack
	addi	$sp, $sp, -36
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	sw	$s5, 20($sp)
	sw	$s6, 24($sp)
	sw	$s7, 28($sp)
	sw	$ra, 32($sp)

	# max size of the array is (N-1)*N*4+(N-1)*4 = max displacement
	move	$s0, $a0
	mult	$s0, $s0
	mflo	$s0
	move	$a0, $s0
	jal	CreateArray

	# pop from stack 
	lw	$s0, 0($sp)
	lw 	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$s5, 20($sp)
	lw	$s6, 24($sp)
	lw	$s7, 28($sp)
	lw	$ra, 32($sp)
	addi	$sp, $sp, 36
	jr	$ra
	
#****** subroutine Initialize Matrix ******
# params[in]: $a0 = dimension of the matrix, $a1 = size of matrix in bytes, $a2 = base address of matrix in heap
# returns: NaN
initMatrix:
	# save registers on stack
	addi	$sp, $sp, -36
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	sw	$s5, 20($sp)
	sw	$s6, 24($sp)
	sw	$s7, 28($sp)
	sw	$ra, 32($sp)

	move	$t0, $a0
	move	$s0, $zero # s0 = currentDisplacement = 0
	addi	$s1, $zero, 1 # s1 = currentValue = 1
	
	addi	$s2, $zero, 1 # s2 = col = 1
	
	beginColLoop:
	bgt	$s2, $t0, completed
	addi	$s3, $zero, 1 # s3 = row = 1
	
		beginRowLoop:
		bgt 	$s3, $t0, colCompleted
		
		# calculate displacement (index of the array)
		addi	$s5, $zero, 4
		addi	$s4, $s2, -1 # s4 = col -1
		mult 	$s4, $t0 # (col-1)* N
		mflo	$s4
		mult	$s4, $s5 # (col-1) * N * 4
		mflo 	$s4
		
		addi	$s6, $s3, -1 # s6 = row - 1
		mult	$s6, $s5 # (row - 1) * 4
		mflo	$s6
		add	$s0, $s4, $s6	# s0 stores current displacement		
		
		add	$s7, $a2, $s0
		sw	$s1, 0($s7) # store in index
		
		addi	$s1, $s1, 1
		
		addi	$s3, $s3, 1
		j beginRowLoop
		
	colCompleted:
	addi	$s2, $s2, 1
	j 	beginColLoop

	completed:
	# pop from stack 
	lw	$s0, 0($sp)
	lw 	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$s5, 20($sp)
	lw	$s6, 24($sp)
	lw	$s7, 28($sp)
	lw	$ra, 32($sp)
	addi	$sp, $sp, 36
	jr	$ra
	
## ***** Get Desired Elemet from Matrix *****
# params[in]: $a0 = i, $a1 = j, $a2 = N , $a3 = base address of matrix
# returns: $v0 = element in matrix
getDesiredElement:
	# save registers on stack
	addi	$sp, $sp, -36
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	sw	$s5, 20($sp)
	sw	$s6, 24($sp)
	sw	$s7, 28($sp)
	sw	$ra, 32($sp)

	move	$t0, $a0
	# calculate displacement (index of the array)
	addi	$s5, $zero, 4
	addi	$s4, $a1, -1 # s4 = col -1
	mult 	$s4, $a2 # (col-1)* N
	mflo	$s4
	mult	$s4, $s5 # (col-1) * N * 4
	mflo 	$s4
	
	addi	$s6, $t0, -1 # s6 = row - 1
	mult	$s6, $s5 # (row - 1) * 4
	mflo	$s6
	add	$s0, $s4, $s6	# s0 stores current displacement		
	
	add	$s7, $a3, $s0
	lw	$v0, 0($s7) # store in index
		
	# pop from stack 
	lw	$s0, 0($sp)
	lw 	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$s5, 20($sp)
	lw	$s6, 24($sp)
	lw	$s7, 28($sp)
	lw	$ra, 32($sp)
	addi	$sp, $sp, 36
	jr	$ra

## ***** subroutine get row major sum *****
# param[in]: $a0 = row number, $a1 = N, $a2 = base address of array in heap
# returns : $v0 = sum of row <$a0>
getRowSum:
	# save registers on stack
	addi	$sp, $sp, -36
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	sw	$s5, 20($sp)
	sw	$s6, 24($sp)
	sw	$s7, 28($sp)
	sw	$ra, 32($sp)
	
	move	$s1, $a1
	move	$s2, $a2

	move	$s3, $zero
	addi	$s4, $zero, 1
			
	beginrowsum:
	bgt	$s4, $s1, endrowsum	
	
	move	$a1, $s4 # set col number
	move	$a2, $s1 # set N
	move	$a3, $s2 # set base address
	jal	getDesiredElement
	add	$s3, $s3, $v0
	addi	$s4, $s4, 1
	j	beginrowsum	
	endrowsum:
	
	move	$v0, $s3
	# pop from stack 
	lw	$s0, 0($sp)
	lw 	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$s5, 20($sp)
	lw	$s6, 24($sp)
	lw	$s7, 28($sp)
	lw	$ra, 32($sp)
	addi	$sp, $sp, 36
	jr	$ra

## ***** subroutine get column major sum *****
# param[in]: $a0 = column number, $a1 = N, $a2 = base address of array in heap
# returns : $v0 = sum of column <$a0>
getColSum:
	# save registers on stack
	addi	$sp, $sp, -36
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	sw	$s5, 20($sp)
	sw	$s6, 24($sp)
	sw	$s7, 28($sp)
	sw	$ra, 32($sp)
	
	move	$s0, $a0
	move	$s1, $a1
	move	$s2, $a2

	move	$s3, $zero
	addi	$s4, $zero, 1
			
	begincolsum:
	bgt	$s4, $s1, endcolsum	
	
	move	$a0, $s4 # set row number
	move	$a1, $s0 # set col number
	move	$a2, $s1 # set N
	move	$a3, $s2 # set base address
	jal	getDesiredElement
	add	$s3, $s3, $v0
	addi	$s4, $s4, 1
	j	begincolsum	
	endcolsum:
	
	move	$v0, $s3
	# pop from stack 
	lw	$s0, 0($sp)
	lw 	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$s5, 20($sp)
	lw	$s6, 24($sp)
	lw	$s7, 28($sp)
	lw	$ra, 32($sp)
	addi	$sp, $sp, 36
	jr	$ra


## util subroutines

## ***** subroutine create array *****
## params[in]: $a0 = size of array to allocate on heap
## returns: $v0 = size of array in bytes, $v1 = base address of the array in heap	
CreateArray:
	# save S registers and RA on stack frame
	addi	$sp, $sp, -36
	sw 	$s0, 0($sp)
	sw 	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	sw	$s5, 20($sp)
	sw	$s6, 24($sp)
	sw	$s7, 28($sp)
	sw 	$ra, 32($sp)
	
	# get the array sizes in bytes (1 word = 4 bytes)
	move	$s0, $a0	
	sll	$s1, $s0, 2
	li	$v0, 9
	move	$a0, $s1
	syscall
	move	$s2, $v0
	# s0 = numbers of elements in array
	# s1 = size of array in bytes for heap allocation
	# s2 = address of the first element of the array in heap
	
	move	$a0, $s0
	move	$a1, $s2

	# return values
	move	$v0, $s1
	move 	$v1, $s2

	# pop from stack and reallocate the save and RA registers
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$s5, 20($sp)
	lw	$s6, 24($sp)
	lw	$s7, 28($sp)
	lw	$ra, 32($sp)
	addi	$sp , $sp, 36
	jr	$ra


	.data
inputDimensionsPrompt:
	.asciiz	"Please Enter the Number of Dimensions for an NxN Matrix: "
invalidDimensionError:
	.asciiz	"The Value of N should be greater than zero!\n"
printDimensionSelected:
	.asciiz "Dimension Chosen for NxN Matrix: "
printArrayPrompt:
	.asciiz "sparse matrix generated as follows: "
MenuPrompt:
	.asciiz "select from options below:\n1)Obtain Row Major Sum\n2)Obtain Column Major Sum\n3)Get Element (i,j)\n4)End\n"
input_i_prompt:
	.asciiz "i: "
input_j_prompt:
	.asciiz "j: "
output_element_prompt:
	.asciiz "element: "
input_row_prompt:
	.asciiz "row number: "
output_row_sum:
	.asciiz	"row sum: "
input_col_prompt:
	.asciiz	"column number: "
output_col_sum:
	.asciiz "column sum: "