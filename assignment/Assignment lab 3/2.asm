.data
	var1: .float 10.0
	var2: .float 1.0
	var3: .float 5.0
.text
main:
#$f0 result
#$f1 10
#$f2 1
#$f3 5
#$f4 除以十的结果
#$f5 temp 除以十
#$f6 最后一位
#$t0 temp
#$t1 counter
	li $v0, 6
	li $a0, 1
	syscall
	
	l.s $f1, var1
	l.s $f2, var2
	l.s $f3, var3
	li $v0, 5
	syscall
	
	beqz $v0, part2
	add $t0, $t0, $v0
loop1:
	mul.s $f0, $f1, $f0
	addi $t1, $t1, 1
	ble $t1, $t0, loop1
	
	floor.w.s $f0, $f0
	cvt.s.w $f0, $f0
	
	div.s $f4, $f0, $f1
	mov.s $f5, $f4
	floor.w.s $f5, $f5
	cvt.s.w $f5, $f5
	floor.w.s $f4, $f4
	cvt.s.w $f4, $f4
	mul.s $f5, $f5, $f1
	sub.s $f6, $f0, $f5
	
	c.le.s $f3, $f6
	mov.s $f0, $f4
	bc1t 0, AddOne
	j End
AddOne:
	add.s $f0, $f0, $f2
End:
	add $t1, $zero, $zero
	beqz $t0, Print1
loop2:
	div.s $f0, $f0, $f1
	addi $t1, $t1, 1
	bne $t1, $t0, loop2
	
Print1:
	li $v0, 2
	mov.s $f12, $f0
	syscall
	j Exit

part2:
	mov.s $f5, $f0
	floor.w.s $f5, $f5
	cvt.s.w $f5, $f5
	mul.s $f5, $f5, $f1
	
	mul.s $f0, $f0, $f1
	floor.w.s $f0, $f0
	cvt.s.w $f0, $f0
	
	sub.s $f6, $f0, $f5
	c.le.s $f3, $f6
	div.s $f0, $f0, $f1
	floor.w.s $f0, $f0
	cvt.s.w $f0, $f0
	bc1t 0, add1
	j print2
add1:
	add.s $f0, $f0, $f2
print2:
	li $v0, 1
	cvt.w.s $f0, $f0
	s.s $f0, 0x10010020
	lw $a0, 0x10010020
	syscall
Exit:
	li $v0, 10
	syscall
	