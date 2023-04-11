.data
    str: .space 100
.text
main:
	li $v0,8 #to get a string
    la $a0,str
    li $a1,100
    syscall
	
	addi $t0, $a0, 0 #addr
	li $t7, 0 #bits_num
	li $t6, 0 #1_num
	 #bit
loop:
	lb $t1, 0($t0)
	slti $t3, $t1, 47
	beq $t3, 1, exit
	bne $t1, 49, once_end
	addi $t6, $t6, 1
once_end:
	addi $t7, $t7, 1
	addi $t0, $t0, 1
	j loop

exit:
	rem $t7, $t7, 2
	rem $t6, $t6, 2 
	xor $a0, $t6, $t7
	li $v0, 1
	slti $a0, $a0, 1
	syscall
