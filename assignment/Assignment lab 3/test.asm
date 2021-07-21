.data
	var1: .float 0.5
.text
main:
	l.s $f12, var1
	round.w.s $f12, $f12
	cvt.s.w $f12, $f12
	li $v0, 2
	syscall
	
	li $v0, 10
	syscall