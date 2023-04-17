.data
	eps: .double 0.000001
	d0: .double 0.0
	d2: .double 2.0
	nd2: .double -2.0
	newline: .asciiz "\n"
	
.text
main:
	li $v0, 7 
	syscall 
	mov.d $f12, $f0  #a
	syscall 
	mov.d $f14, $f0  #b
	syscall 
	mov.d $f16, $f0  #c
	ldc1 $f10, eps  #eps
	ldc1 $f28, d2
	ldc1 $f30, nd2  #-2.0
	
	mul.d $f26, $f30, $f12
	div.d $f22, $f14, $f26
	
	sub.d $f20, $f22, $f10
	add.d $f24, $f22, $f10
	
	mul.d $f28, $f28, $f12 #2a
	
	jal calc_small
	jal calc_large
	
	j end
	
calc_small:
	mul.d $f2, $f12, $f20
	add.d $f2, $f2, $f14
	mul.d $f2, $f2, $f20
	add.d $f2, $f2, $f16
	abs.d $f4, $f2
	
	c.lt.d 7, $f4, $f10
	bc1t 7, small_complete

	mul.d $f6, $f28, $f20
	add.d $f6, $f6, $f14
	div.d $f4, $f2, $f6
	sub.d $f20, $f20, $f4
	j calc_small
small_complete:
	jr $ra
	
calc_large:
	mul.d $f2, $f12, $f24
	add.d $f2, $f2, $f14
	mul.d $f2, $f2, $f24
	add.d $f2, $f2, $f16
	
	abs.d $f4, $f2
	c.lt.d 5, $f4, $f10
	bc1t 5, large_complete
	
	ldc1 $f6, d2
	mul.d $f6, $f28, $f24
	add.d $f6, $f6, $f14
	div.d $f4, $f2, $f6
	sub.d $f24, $f24, $f4
	j calc_large
large_complete:
	jr $ra
	
end:
	c.lt.d 6, $f20, $f24
	bc1t 6, print
	mov.d $f2, $f24
	mov.d $f24, $f20
	mov.d $f20, $f2
print:
	li $v0, 3
	mov.d $f12, $f20
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 3
	mov.d $f12, $f24
	syscall
