.include "macro_print_str.asm"
.data 
	var1:	.word	19
	var2:	.word	12
	var5:	.word	1111111
	var6:	.word	2222222
	arr: 	.word	4, 3

	str1:	.asciiz	"Immediate value addressing:\n"
	str2:	.asciiz	"Direct addressing:\n"
	str3:	.asciiz	"Indirect addressing:\n"
	str4:	.asciiz	"Baseline addressing:\n"
	str5:	.asciiz	"\n"
	str6:	.asciiz	"+"
	str7:	.asciiz	"-"
	str8:	.asciiz	"*"
	str9:	.asciiz	"/"
	str10:	.asciiz	"="
	str11:	.asciiz	" (In binary form)"
	str12:	.asciiz	"......."
	res:	.word	0x10010100
.text

main:
	lw $t7, res
	#immediate value addressing
	li $v0, 4
	la $a0, str1
	syscall
	
	li $t1, 20
	li $t2, 30
	la $a0, ($t1)
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, str6
	syscall

	la $a0, ($t2)
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, str10
	syscall

	add $t0, $t1, $t2
	la $a0, ($t0)
	li $v0, 1
	syscall
	sw $t0, ($t7)
	
	li $v0, 4
	la $a0, str5
	syscall
	
	#direct addressing
	li $v0, 4
	la $a0, str2
	syscall

	lw $t1, var1
	lw $t2, var2
	la $a0, ($t1)
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, str7
	syscall

	la $a0, ($t2)
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, str10
	syscall

	sub $t0, $t1, $t2
	la $a0, ($t0)
	li $v0, 1
	syscall
	sw $t0, 4($t7)
	
	li $v0, 4
	la $a0, str5
	syscall
	
	#indirect addressing
	li $v0, 4
	la $a0, str3
	syscall
	
	la $t1, var5
	la $t2, var6 # 将两个数据的地址存储到寄存器$t1和$t2中
	lw $t3, ($t1)
	lw $t4, ($t2)
	
	la $a0, ($t3)
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, str8
	syscall

	la $a0, ($t4)
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, str10
	syscall

	mul $t0, $t3, $t4
	mfhi $a0
	mfhi $t5 # 将高位的值存入寄存器
	sw $t0, 8($t7)
	sw $t5, 12($t7)
	
	li $v0, 35
	syscall
	mflo $a0
	syscall
	# 输出的答案应为 hi*2^32 + 2^32 - lo;但我没搞定怎么操作一个64位的数.
	li $v0, 4
	la $a0, str11
	syscall
	li $v0, 4
	la $a0, str5
	syscall
	
	
	# baseline addressing
	li $v0, 4
	la $a0, str4
	syscall
	
	la $t6, arr
	lw $t3, ($t6)
	lw $t4, 4($t6) # baseline addressing
	
	la $a0, ($t3)
	li $v0, 1
	syscall
	li $v0, 4
	la $a0, str9
	syscall
	la $a0, ($t4)
	li $v0, 1
	syscall
	li $v0, 4
	la $a0, str10
	syscall
	
	div $t3, $t4
	mfhi $t3
	mflo $t4
	sw $t3, 16($t7)
	sw $t4, 20($t7)
	# 存储进内存
	mfhi $a0
	li $v0, 1
	syscall
	li $v0, 4
	la $a0, str12
	syscall
	mflo $a0
	li $v0, 1
	syscall
	
end
