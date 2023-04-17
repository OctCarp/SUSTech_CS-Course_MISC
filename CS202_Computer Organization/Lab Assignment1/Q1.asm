.data
	filename: .space 100
	buffer: .space 400000

.text
main:
	#read filename
	la $a0, filename
	li $v0, 8
	li $a1, 18
	syscall

	# open file
	li $v0, 13
	la $a0, filename
	li $a1, 0 # 0 for read
	li $a2, 0
	syscall
	move $s6, $v0  # save file descriptor

	# read file
	li $v0,14
	move $a0,$s6  # load file descriptor
	la $a1, buffer  # save read content to buffer space
	li $a2, 40  # reads 40 ascii chars
	syscall

	# close file
	li $v0, 16
	move $a0, $s6 # load file descriptor
	syscall

	addi $t0, $a1, 0
	li $t7, 0
	
	li $t9, 0
	li $a2, 0

method_loop:	
	slti $t8, $t9, 10
	beq $t8, 0, print
	beq $t9, 5, method_else
	jal read
	add $t7, $t7, $t6
	j method_end
method_else:
	addi $t0, $t0, 4
method_end:
	addi $t9, $t9, 1
	j method_loop

read:
	li $t1, 0
	li $t6, 0
loop:
	slti $t5, $t1, 4
	beq $t5, 0, exit
	mul $t6, $t6, 16
	lb $t2, 0($t0)
	
	slti $t5, $t2, 97
	beq $t5, 0, char
	addi $t2, $t2, -48
	j calc
char:
	addi $t2, $t2, -87
calc:
	add $t6, $t6, $t2
	addi $t1, $t1, 1
	addi $t0, $t0, 1
	j loop
exit: jr $ra
	
print:
	div $t6, $t7, 65536
	rem $t7, $t7, 65536
	add $t8, $t7, $t6
	lui $a0, 65535
	add $a0, $a0, $t8
	not $a0, $a0
	
	li $v0, 34
	syscall

