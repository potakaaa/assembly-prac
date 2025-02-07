.data
	num1: .word 10
	num2: .word 5
	sum: .word 0
	strSum: .asciiz "\n"

.text
	lw $t0, num1
	lw $t1, num2
	
	add $t2, $t0, $t1
	
	sw $t2, sum
	
	li $v0, 1
	move $a0, $t2
	syscall
	
	li $v0, 4
	la $a0, strSum
	syscall
	
	li $v0, 10
	syscall
