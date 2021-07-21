.data 
	var1:	.asciiz	"apply stack\n"
	var2:	.asciiz	"release stack\nreturn:"
	var3:	.asciiz	"\n"
.text
	li $v0, 5
	syscall
	addi $s0, $v0, 0 # $s0 中存储了底数
	li $v0, 5
	syscall 
	addi $s1, $v0, 0 # $s1 中存储了指数
	addi $s2, $zero, 1 # $s2 中存储了当前数字
	
	li $t0, -1
loop1:
	li $v0, 4
	la $a0, var1
	syscall
	addi $t0, $t0, 1
	bne $t0, $s1, loop1
	
	li $t0, -1
loop2:	
	li $v0, 4
	la $a0, var2
	syscall
	li $v0, 1
	add $a0, $zero, $s2
	syscall
	li $v0, 4
	la $a0, var3
	syscall	
	mul $s2, $s2, $s0
	addi $t0, $t0, 1
	bne $t0, $s1, loop2
	
	div $s2, $s0
	li $v0, 1
	mflo $a0
	syscall
li $v0, 10
syscall