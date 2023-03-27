# x = (a + b + 4)/ (2 * a)

.data
p1: .asciiz "Enter a: "
p2: .asciiz "Enter b: "
p3: .asciiz "x = "

.text
main:
    li $v0, 4
    la $a0, p1
    syscall
    li $v0, 5
    syscall
    move $t0, $v0 #$t0 = a
    li $v0, 4
    la $a0, p2
    syscall
    li $v0, 5
    syscall
    move $t1, $v0 #$t1 = b
    add $t2, $t0, $t1 #$t2 = a+b
    addi $t2, $t2, 4 #$t2 = a + b + 4
    mul $t3, $t0, 2 #$t3 = 2 * a
    div $t2, $t3
    mflo $t4
    move $t5, $t4
    li $v0, 4
    la $a0, p3
    syscall
    li $v0, 1
    move $a0, $t5
    syscall
    li $v0, 10
    syscall
    


