.data 
	var1: .double 4
	var3: .double 3
	var2: .double 2
.text
main:
#$t0 store that whether it will be add or sub
#$f2 store that the fenmu of the div
#$f4 is the temp value
#$f6 is the fenzi
#$f12 is the answer
#$f8 is the jing du
#$f0 the sub
#$f14 the last answer
	li $v0, 7
	syscall
	mov.d $f8, $f0 
	l.d $f14 var1
	l.d $f6, var1
	l.d $f12, var1
	l.d $f2, var3
	l.d $f16, var2
sub1:	
	addi $t0, $t0, 1
	div.d $f4, $f6, $f2
	sub.d $f12, $f12, $f4
	j judge
add1:
	addi $t0, $t0, -1
	div.d $f4, $f6, $f2
	add.d $f12, $f12, $f4
	j judge

judge:
	sub.d $f0, $f14, $f12
	abs.d $f0, $f0
	c.le.d $f0, $f8
	bc1t 0, Exit
	mov.d $f14, $f12
	add.d $f2, $f2, $f16
	beq $t0, $zero, sub1
	j add1
	
Exit:
	li $v0, 3
	syscall
	li $v0, 10
	syscall
