.data
	input1: .asciiz "Enter First Number: "
	input2: .asciiz "Enter Second Number: "
	resultMsg: .asciiz "The Result is: "
	newln: .asciiz "\n"

.text
	li $v0, 4
	la $a0, input1
	syscall
	
	li $v0, 5
	syscall
	move $t0, $v0
	
	li $v0, 4
	la $a0, input2
	syscall
	
	li $v0, 5
	syscall
	move $t1, $v0
	
	add $t2, $t0, $t1
	
	li $v0, 4
	la $a0, resultMsg
	syscall
	
	li $v0, 1
	move $a0, $t2
	syscall
	
	li $v0, 4
	la $a0, newln
	syscall
	
	