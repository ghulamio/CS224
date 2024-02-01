# ========== TEXT SECTION ============ ###
		.text 
	.globl	__start
	
__start:
	jal main # interactive menu 
	li $v0, 10 # exit the programme
	syscall
		
				
# interactive menu
# WORKING [+]
main: 
	# save return address to the stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	# Display intro message
	li $v0, 4 
	la $a0, prompt # Prompt the assignment Task
	syscall
	menu:
		# Call display
		jal display
		# Ask user to enter option
		li $v0, 4 
		la $a0, msgOption
		syscall
		#user option selection
		li $v0, 5 # v0 read integer
		syscall
		# Call sub programs according to options
		beq $v0, 2, opt2
		beq $v0, 3, opt3
	    beq $v0, 7, opt7
	    beq $v0, 8, opt8
	    beq $v0, 9, optExit
 		opt2:
			li $v0, 4
			la $a0, msgN
			syscall

			li $v0, 5 # read N
			syscall

			move $s0, $v0 # N -> $s0
			mul $s2, $s0, $s0 # N * N -> $s2
			mul $a0, $s2, 4 # N * N * 4 -> $a0
			li $v0, 9 # malloc
			syscall
			move $s1, $v0 # matrix base -> $s1

			jal fillConsecutiveMatrix # fill the matrix with consecutive integers

			jal displayMatrix
 			j loopBack
 		opt3:
 			# takes row and column and displays the element
 			li $v0, 4 # request to read row  ([i], j)
 			la $a0, msgRow
 			syscall 
 			li $v0, 5 # read row i
 			syscall
 			move $t0, $v0 # row -> $t0
 			li $v0, 4 # request to read col (i, [j])
 			la $a0, msgCol
 			syscall 
 			li $v0, 5 # read col j
 			syscall
 			move $t1, $v0 # col -> $t1
 			# calculate the position
 			subi $t0, $t0, 1 # (i - 1) -> $t0
 			mul $t0, $t0, $s0 # (i - 1) * N -> $t0
 			mul $t0, $t0, 4 # (i - 1) * N * 4 -> $t0
 			subi $t1, $t1, 1 # (j - 1) -> $t1
 			mul $t1, $t1, 4 # (j - 1) * 4 -> $t1
 			add $t0, $t0, $t1 # (i - 1) * N * 4 + (j - 1) * 4 -> $t0
 			add $t2, $t0, $s1 # effective address of the position
 			# display result prompt
 			li $v0, 4 
 			la $a0, msgOpt3Res # result
			syscall
			# display the item
 			lw $a0, 0($t2)
 			li $v0, 1
 			syscall
 			j loopBack
 		opt7:
 			# obtain row by row summation
 			# jal sumRowWise

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


 			j loopBack
 		opt8:
 		 	# obtain col by col summation
 			jal sumColWise
 			j loopBack
	    # execute main loop again
	    loopBack:
	    	j menu # go back to menu	
	    optExit: # exit the loop
	# load back the return address
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra # go to

	
# Get Item
# Returns item at the position
# row -> $a0 
# col -> $a1 
# item -> $v0
# WORKING [+]
getItem:
	addi $sp, $sp, -16 # malloc
	sw $ra, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s0, 12($sp)
	# =================
	move $t0, $a0 # row -> $t0
 	move $t1, $a1 # col -> $t1
 	# calculate the position
 	subi $t0, $t0, 1 # (i - 1) -> $t0
 	mul $t0, $t0, $s0 # (i - 1) * N -> $t0
 	mul $t0, $t0, 4 # (i - 1) * N * 4 -> $t0
 	subi $t1, $t1, 1 # (j - 1) -> $t1
 	mul $t1, $t1, 4 # (j - 1) * 4 -> $t1
 	add $t0, $t0, $t1 # (i - 1) * N * 4 + (j - 1) * 4 -> $t0
 	add $t2, $t0, $s1 # effective address of the position
	# fetch the item
 	lw $v0, 0($t2)
	# =================
	# calloc
	lw $s0, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 16
	jr $ra # goto
	
# Displays matrix row by row
# WORKING [+]
displayMatrix:
	addi $sp, $sp, -12 # malloc
	sw $ra, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	# =================
	li $t0, 2 # use to control end of line (endl)
	sumRowLoop2:
		lw $a0, 0($s1) # current item -> $a0
		li $v0, 1
		syscall # print current element
		li $v0, 4 # matrix construction
     	la $a0, wSpace
        syscall 
		addi $s1, $s1, 4 # iterate matrix
		subi $s2, $s2, 1
		ble $t0, $s0, jEnter
		li $t0, 1 # use to control end of line (endl)
		li $v0, 4 # matrix construction
     	la $a0, endl
        syscall 
		jEnter:
		addi $t0, $t0, 1 
		bgt $s2, $0, sumRowLoop2
	# calloc
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra # goto


# Obtains col by col summations of elements within the matrix
# Column-major representation
# WORKING [+]
sumColWise:
	addi $sp, $sp, -12 # malloc
	sw $ra, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	# ======= 
	mul $t3, $s0, 4 # row offset -> $t3
	li $t0, 0 # sum -> $t0 
	li $t1, 0 # (col - 1) -> $t1
	coLoopNextRow:
		mul $t4, $t1, 4 # col offset -> $t4
		move $t2, $0 # row - 1 -> $t2  
		add $t5, $s1, $t4 # effective memory address -> $t5
		lw $t7, 0($t5) # current item -> $t7
		add $t0, $t7, $t0 # recalculate sum
		cLoopNextCol:
			add $t5, $t3, $t5 # effective memory address -> $t5
			lw $t7, 0($t5) # current item -> $t7
			add $t0, $t7, $t0 # recalculate sum
			addi $t2, $t2, 1 # row++
			blt $t2, $s0, cLoopNextCol # row < N keep continue
		addi $t1, $t1, 1 # col++
		blt $t1, $s0, coLoopNextRow
	# display result
	li $v0, 4 # result message
	la $a0, msgOpt8Res 
	syscall
	# print the result
	addi $a0, $t0, 0
	li $v0, 1
	syscall 
	# ======= 
	# calloc
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra # goto

# Obtains row by row summations of elements within the matrix
# Row-major representation
# WORKING [+]
sumRowWise:
	addi $sp, $sp, -12 # malloc
	sw $ra, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	li $t0, 0 # sum -> $t0
	move $t2, $s2 # Counter for items
	sumRowLoop:
		lw $t1, 0($s1) # current item -> $t1
		addi $s1, $s1, 4 #iterate over the matrix 
		add $t0, $t0, $t1 # sum -> $t0
		subi $t2, $t2, 1
		bgt $t2, $0, sumRowLoop
	li $v0, 4 # result message
	la $a0, msgOpt7Res 
	syscall
	# print the result
	addi $a0, $t0, 0
	li $v0, 1
	syscall 
	# calloc
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra # goto
	
# Fills the matrix with consecutive integers
fillConsecutiveMatrix:	
	addi $sp, $sp, -12 # matrix base and return address saved
	sw $ra, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	# start filling from 1
	li $t1, 1 # item value -> $t1
	writeItems:
		sw $t1, 0($s1) # write to the array
		addi $s1, $s1, 4 # next item of the matrix
		addi $t1, $t1, 1 # increment element
		sle  $t3, $t1, $s2
		beq $t3, 1, writeItems
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra # goto
	

# Menu display interface
# WORKING [+]
display:
	addi $sp, $sp, -4 # allocate stack space
	sw $ra, 0($sp)
	li $v0, 4 
	# print the options
	la $a0, msgMenu
	syscall
	la $a0, msgOpt2
	syscall
	la $a0, msgOpt3
	syscall
	la $a0, msgOpt7
	syscall
	la $a0, msgOpt8
	syscall
	la $a0, msgExitOpt
	syscall 
	lw $ra, 0($sp) # goto return address
	addi $sp, $sp, 4
	jr $ra # goto

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
	
	move 	$a0, $s3 # set row number
	move	$a1, $s4 # set col number
	# jal	getDesiredElement
	jal getItem
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

# ========== DATA SECTION ============ ### 
		.data 
prompt:		.asciiz	 "Interactive menu to perform operations on an user defined matrix \n"
msgOption:	.asciiz   "\nPlease choose an option: "
msgMenu: .asciiz "\n\n=========== MENU =============="
msgOpt2: .asciiz	"\n 1. Create matrix (NxN) with consecutive values"
msgOpt3: .asciiz    "\n 2. Display the target item (row, col)"
msgOpt7: .asciiz    "\n 3. Obtain sum of matrix elements (Row by row)"
msgOpt8: .asciiz    "\n 4. Obtain sum of matrix element (Column by column) "
msgExitOpt: .asciiz "\n 5. Exit"
msgN: .asciiz "\nPlease enter N of (NxN) matrix: " 
msgRow: .asciiz "\nPlease enter Row number i [1:N]: " 
msgCol: .asciiz "\nPlease enter Column number j [1:N]: " 
msgOpt3Res: .asciiz "\nItem in the given row & col: " 
msgOpt7Res: .asciiz "\nSum of elements obtained in terms of Row-Major iteration (row by row): " 
msgOpt8Res: .asciiz "\nSum of elements obtained in terms of Column-Major iteration (col by col): " 
msgOpt5Res: .asciiz  "\nTrace of the NxN matrix: " 
msgOpt6Res: .asciiz  "\nTrace like summation of the NxN matrix: " 
endl: .asciiz "\n"
wSpace: .asciiz " "
input_row_prompt: .asciiz "row number: "
output_row_sum: .asciiz	"row sum: "
input_col_prompt: .asciiz	"column number: "
output_col_sum: .asciiz "column sum: "