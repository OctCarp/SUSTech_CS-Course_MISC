.data
	op: .space 1000
	x: .space 1000
	f0: .float 0.0
	f1: .float 1.0
	nf1: .float -1.0
	f2: .float 2.0

.text
main:
	lwc1 $f20, f1 #counter i
	lwc1 $f12, f0 #sum
	li $t7, 1 #postive
	lwc1 $f1, f1 #n
	lwc1 $f9, f2 #2
	lwc1 $f18, f1 #1.0
	lwc1 $f19, nf1 #-1.0
	lwc1 $f24, f0 #0
	li $t1, 1 #n 
	
	li $v0, 6
	syscall
	add.s $f21, $f0, $f24  #op

	li $v0, 6
	syscall

	add.s $f22, $f0, $f24 #x

	
loop:
	c.le.s 1, $f20, $f21 #i <= op
	bc1f 1, exit
	
	lwc1 $f23, f0
	jal numer_calc
	jal deno_calc
	
	beq $t7, 1, posi
	li $t7, 1
	mul.s $f23, $f23, $f19
	j one_loop_end
posi:
	li $t7, 0	
one_loop_end:
	add.s $f1, $f1, $f9 #n+=2.0
	add.s $f20, $f20, $f18 #i+=1.0
	add.s $f12, $f12, $f23 #ans+=
	addi $t1, $t1, 2 
	j loop

numer_calc:
	add.s $f3, $f22, $f24
	add.s $f4, $f3, $f24
	li $t2, 2
numer_loop:
	blt $t1, $t2, exit_n_loop
	mul.s $f3, $f3, $f4
	addi $t2, $t2, 1
	j numer_loop		
exit_n_loop:
	add.s $f23, $f3, $f24
	jr $ra

deno_calc:
	add.s $f6, $f1, $f24 #part
	add.s $f7, $f18, $f24 #part_sum=1.0
	li $t2, 1
deno_loop:
	blt $t1, $t2, exit_d_loop
	mul.s $f7, $f7, $f6
	sub.s $f6, $f6, $f18 
	addi $t2, $t2, 1
	j deno_loop		
exit_d_loop:
	div.s $f23, $f23, $f7
	jr $ra

exit:
	li $v0, 2
	syscall
