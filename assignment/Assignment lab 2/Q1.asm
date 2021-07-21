.data
	var1:	.byte 0x2A
	var2:	.byte 0x3D
.text
main:
	li $s0, 0x10010004
	li $s1, 10
	li $v0, 5
	syscall
	add $t0, $v0, $zero
	li $v0, 5
	syscall
	add $t1, $v0, $zero

	
	mul $t2, $t1, $t0
	
	addi $t0, $t0, 48
	addi $t1, $t1, 48
	sb $t0, ($s0)
	lb $t0, var1
	sb $t0, 1($s0)
	sb $t1, 2($s0)
	lb $t1, var2
	sb $t1, 3($s0)
	
	div $t2, $s1
	mflo $t2
	bne $t2, $zero, Else
	mfhi $t2
	addi $t2, $t2, 48
	sb $t2, 4($s0)
	j Exit
Else:	
	addi $t2, $t2, 48
	sb $t2, 4($s0)
	mfhi $t2
	addi $t2, $t2, 48
	sb $t2, 5($s0)
Exit:
	li $v0, 4
	move $a0, $s0
	syscall
	
	li $v0, 10
	syscall