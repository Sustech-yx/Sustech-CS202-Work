.data
	var0: 	.asciiz	"1*1=1 \n1*2=2  2*2=4 \n1*3=3  2*3=6  3*3=9 \n1*4=4  2*4=8  3*4=12 4*4=16\n1*5=5  2*5=10 3*5=15 4*5=20 5*5=25\n1*6=6  2*6=12 3*6=18 4*6=24 5*6=30 6*6=36\n1*7=7  2*7=14 3*7=21 4*7=28 5*7=35 6*7=42 7*7=49\n1*8=8  2*8=16 3*8=24 4*8=32 5*8=40 6*8=48 7*8=56 8*8=64\n1*9=9  2*9=18 3*9=27 4*9=36 5*9=45 6*9=54 7*9=63 8*9=72 9*9=81"
.text
main:
	li $t1, 1
	li $t2, 2
	li $t3, 3
	li $t4, 4
	li $t5, 5
	li $t6, 6
	li $t7, 7
	li $t8, 8
	
	li $v0, 5
	syscall
	addi $t0, $v0, 0
	beq $t0, $t1, S1
	beq $t0, $t2, S2
	beq $t0, $t3, S3
	beq $t0, $t4, S4
	beq $t0, $t5, S5
	beq $t0, $t6, S6
	beq $t0, $t7, S7
	beq $t0, $t8, S8
	
	li $a0, 0x100100fc
	j Flag
S1:
	li $a0, 0x10010000
	j Flag
S2:
	li $a0, 0x10010007
	j Flag
S3:
	li $a0, 0x10010015
	j Flag
S4:
	li $a0, 0x1001002a
	j Flag
S5:
	li $a0, 0x10010046
	j Flag
S6:
	li $a0, 0x10010069
	j Flag
S7:
	li $a0, 0x10010093
	j Flag
S8:
	li $a0, 0x100100c4

Flag:
	li $v0, 5
	syscall
	addi $t0, $v0, 0
	beq $t0, $t1, E1
	beq $t0, $t2, E2
	beq $t0, $t3, E3
	beq $t0, $t4, E4
	beq $t0, $t5, E5
	beq $t0, $t6, E6
	beq $t0, $t7, E7
	beq $t0, $t8, E8
	
	j Exit
E1:
	sb $zero, 0x10010006
	j Exit	
E2:
	sb $zero, 0x10010014
	j Exit	
E3:
	sb $zero, 0x10010029
	j Exit	
E4:
	sb $zero, 0x10010045
	j Exit	
E5:
	sb $zero, 0x10010068
	j Exit	
E6:
	sb $zero, 0x10010092
	j Exit	
E7:
	sb $zero, 0x100100c3
	j Exit	
E8:
	sb $zero, 0x100100fb
	j Exit	
	
Exit:
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall