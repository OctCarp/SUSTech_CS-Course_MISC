.data
	in: .space 10000
	bin: .space 100000

	yes: .asciiz " is a binary palindrome"
	no: .asciiz " is not a binary palindrome"
	ascode: .asciiz "the ASCII code is "
	binary: .asciiz "the binary code is "

.text
main:
	li $v0, 8 #to get a string
	la $a0, in
	li $a1, 100
	syscall

	la $s1, in
	la $s2, bin
	li $v0, 11

	addi $t0, $s1, 0 #byte in pointer
	addi $t1, $s2, 0 #byte out pointer
	lb $t2, 0($t0)
	jal convert
	addi $t0, $t0, 1

loop:
	lb $t2, 0($t0) #current ascii
	slti $v1, $t2, 32
	beq $v1, 1, check
	
	li $t7, 45
	sb $t7, 0($t1)
	addi $t1, $t1, 1
	
	jal convert
	addi $t0, $t0, 1
	j loop

convert:
	addi $a0, $t2, 0
	syscall
	
	li $t9 64
	li $t7, 48
	sb $t7, 0($t1)
	addi $t1, $t1, 1
convert_loop:
	slti $v1, $t9, 1
	beq $v1, 1, convert_loop_exit
	div $t8, $t2, $t9
	addi $t8, $t8, 48
	sb $t8, 0($t1)
	addi $t1, $t1, 1
	
	rem $t2, $t2, $t9
	div $t9, $t9, 2
	j convert_loop
convert_loop_exit:
	jr $ra

check:
	addi $t0, $s2, -1
check_loop:
	addi $t0, $t0, 1
	addi $t1, $t1, -1
	lb $t2, 0($t0)
	lb $t3, 0($t1)
	bne $t2, $t3, check_fail
	addi $t4, $t1, -1
	beq $t4, $t0, check_success
	beq $t1, $t0, check_success
	j check_loop

check_fail:
	li $v0, 4
	la $a0, no
	syscall
	j ccl
check_success:
	li $v0, 4
	la $a0, yes
	syscall
ccl:
	li $v0, 11
	li $a0, 10
	syscall
	
	li $v0, 4
	la $a0, ascode
	syscall
	
	li $v0, 1
	addi $t0, $s1, 0
	lb $a0, 0($t0)
	syscall
	
	addi $t0, $t0, 1
ccl_loop:
	lb $t2, 0($t0)
	slti $v1, $t2, 32
	beq $v1, 1, ccl_loop_exit
	li $v0, 11
	li $a0, 45
	syscall
	li $v0, 1
	addi $a0, $t2, 0
	syscall
	
	addi $t0, $t0, 1
	j ccl_loop
ccl_loop_exit:
	li $v0, 11
	li $a0, 10
	syscall
	
	li $v0, 4
	la $a0, binary
	syscall
	la $a0, bin
	syscall
