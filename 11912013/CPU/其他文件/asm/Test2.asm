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
 	ori $23, $zero, 7
    lui $1,  0xFFFF
    ori $28, $1, 0xF000
magic:
    # $8 is the val, $9 is the value which will be written in low and $10 is in high
    # $6 is x, $7 is y
    # $2 and $3 are used to the counter
    lw $1, 0xC72($28)
    srl $1, $1, 5
    beq $1, $16, case1
	beq $1, $17, case2
	beq $1, $18, case3
	beq $1, $19, case4
	beq $1, $20, case5
	beq $1, $21, case6
	beq $1, $22, case7
    beq $1, $23, case8
    sw $9, 0xC60($28) 
    sw $10,0xC62($28)
case1:
    lw $4, 0xC70($28)
    add $6, $zero, $4
    add $7, $zero, $4
    srl $6, $6, 8
    sll $7, $7, 24
    srl $7, $7, 24
    addi $10, $6, 0
    addi $9, $7, 0
    sw $9, 0xC60($28) 
    sw $10,0xC62($28)
    j Exit

case2:
    add $8, $6, $7
    sll $9, $8, 16
    srl $9, $9, 16
    srl $10, $8, 16
    sw $9, 0xC60($28) 
    sw $10,0xC62($28)
    j Exit

case3:
    sub $8, $6, $7
    addi $9, $8, 0
    sll $9, $9, 16
    srl $9, $9, 16
    srl $10, $8, 16
    sw $9, 0xC60($28) 
    sw $10,0xC62($28)
    j Exit

case4:
    sllv $8, $6, $7
    addi $9, $8, 0
    sll $9, $9, 16
    srl $9, $9, 16
    srl $10, $8, 16
    sw $9, 0xC60($28) 
    sw $10,0xC62($28)
    j Exit

case5:
    srlv $8, $6, $7
    addi $9, $8, 0
    sll $9, $9, 16
    srl $9, $9, 16
    srl $10, $8, 16
    sw $9, 0xC60($28) 
    sw $10,0xC62($28)
    j Exit

case6:
    slt $8, $7, $6
    addi $9, $8, 0
    sll $9, $9, 16
    srl $9, $9, 16
    srl $10, $8, 16
    sw $9, 0xC60($28) 
    sw $10,0xC62($28)
    j Exit

case7:
    and $8, $6, $7
    addi $9, $8, 0
    sll $9, $9, 16
    srl $9, $9, 16
    srl $10, $8, 16
    sw $9, 0xC60($28) 
    sw $10,0xC62($28)
    j Exit

case8:
    xor $8, $6, $7
    addi $9, $8, 0
    sll $9, $9, 16
    srl $9, $9, 16
    srl $10, $8, 16
    sw $9, 0xC60($28) 
    sw $10,0xC62($28)
    j Exit


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