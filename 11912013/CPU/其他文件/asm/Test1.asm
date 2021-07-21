.data 0x0000
    buf: .word 0x0000
.text 0x0000
ini:
    ori $16, $zero, 0
    ori $17, $zero, 1
    ori $18, $zero, 2
    ori $19, $zero, 3
    ori $20, $zero, 4
    ori $21, $zero, 5
    ori $22, $zero, 6
 	ori $23, $zero, 0x0D3E
    ori $24, $zero, 0xAAAA
 	ori $25, $zero, 0x5555
	lui $1,  0xFFFF
    ori $28, $1, 0xF000
	
magic:
	lw $1, 0xC72($28)
	srl $1, $1, 5
	beq $1, $16, case1
	beq $1, $17, case2
	beq $1, $18, case3
	beq $1, $19, case4
	beq $1, $20, case5
	beq $1, $21, case6
	beq $1, $22, case7
	sw $8, 0xC60($28)
	sw $10,0xC62($28)
	j Exit
case1:
	sw $zero, 0xC62($28)
	beq $4, $zero, subflag1
	subflag2:
		addi $4, $4, -1
		sw $24, 0xC60($28)
		j Exit
	subflag1:
		addi $4, $4, 1
		sw $25, 0xC60($28)
		j Exit
case2:
	lw $9, 0xC70($28)
	sll $9, $9, 15
	srl $8, $9, 15
	srl $10,$9, 31
	sw $8, 0xC60($28)
	sw $10,0xC62($28)
	j Exit

case3:
	srl $8, $9, 15
	addi $8, $8, 1
	sll $9, $8, 15
	srl $10,$9, 31
	sw $8, 0xC60($28)
	sw $10,0xC62($28)
	j Exit

case4:
	srl $8, $9, 15
	addi $8, $8, -1
	sll $9, $8, 15
	srl $10,$9, 31
	sw $8, 0xC60($28)
	sw $10,0xC62($28)
	j Exit

case5:
	srl $8, $9, 15
	sll $8, $8, 1
	sll $9, $8, 15
	srl $10,$9, 31
	sw $8, 0xC60($28)
	sw $10,0xC62($28)
	j Exit

case6:
	srl $8, $9, 15
	srl $8, $8, 1
	sll $9, $8, 15
	srl $10,$9, 31
	sw $8, 0xC60($28)
	sw $10,0xC62($28)
	j Exit

case7:
	sra $9, $9, 1
	srl $8, $9, 15
	srl $10,$9, 31
	sw $8, 0xC60($28)
	sw $10,0xC62($28)

Exit:
	jal loop
	j magic
loop:
	addi $2, $zero, 0
	oloop:
		addi $2, $2, 1
		addi $3, $zero, 0
		iloop:
			addi $3, $3, 1
			bne $3, $23, iloop
		bne $2, $23, oloop
	jr $31