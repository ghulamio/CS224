# Declare the variables
.data
  n: .word 0
  matrix: .space 400
  rowSum: .word 0
  colSum: .word 0
  row: .word 0
  col: .word 0

# Start the main program
.text
main:

  # Get the matrix size from the user
  la $a0, n
  li $v0, 5
  syscall

  # Allocate memory for the matrix
  la $a0, matrix
  li $v0, 9
  syscall

  # Initialize the matrix elements column by column with consecutive values
  li $t0, 0
  li $t1, 1
  mul 
  beq $t0, n * n, endInit
  sw $t1, matrix($t0)
  addi $t0, $t0, 4
  addi $t1, $t1, 1
  j init
endInit:

  # Obtain the summation of matrix elements row-major (row by row) summation
  li $t0, 0
  li $t1, 0
  beq $t0, n, endRowSum
  add $t1, $t1, matrix($t0)
  addi $t0, $t0, 4
  j RowSum
endRowSum:
  sw $t1, rowSum

  # Obtain the summation of matrix elements column-major (column by column) summation
  li $t0, 0
  li $t1, 0
  beq $t0, n, endColSum
  add $t1, $t1, matrix($t0)
  addi $t0, $t0, 4
  j ColSum
endColSum:
  sw $t1, colSum

  # Display the summation of matrix elements
  la $a0, rowSum
  li $v0, 1
  syscall
  li $a0, '\n'
  li $v0, 11
  syscall
  la $a0, colSum
  li $v0, 1
  syscall
  li $a0, '\n'
  li $v0, 11
  syscall

  # Display desired elements of the matrix by specifying its row and column member.
  li $v0, 5
  syscall
  move $row, $v0
  li $v0, 5
  syscall
  move $col, $v0
  la $a0, matrix
  add $a0, $a0, ($row * n)
  add $a0, $a0, $col
  lw $a0, 0($a0)
  li $v0, 1
  syscall
  li $a0, '\n'
  li $v0, 11
  syscall

  # Free the allocated memory.
  li $v0, 9
  la $a0, matrix
  syscall

  # Exit the program
  li $v0, 10
  syscall
