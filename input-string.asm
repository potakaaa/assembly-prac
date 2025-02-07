.data
	name: .asciiz "What's your name? "
	age: .asciiz "How old are you? "
	address: .asciiz "Where do you live? "
	language: .asciiz "What's your favorite programming language? "
	nameGreet: .ascii "Your name is "
	ageGreet: .ascii "You are "
	addGreet: .ascii "You live in "
	langGreet: .ascii "You love coding in "
	
	newln: .asciiz "\n"
	nameBuffer: .space 50
	addressBuffer: .space 50
	langBuffer: .space 50
	
.text
	li $v0, 4
	la $a0, name
	syscall
	
	li $v0, 8
	la $a0, nameBuffer
	li $a1, 50
	syscall
	
	li $v0, 4
	la $a0, age
	syscall
	
	li $v0, 5
	syscall
	move $t0, $v0
    	
    	li $v0, 4
	la $a0, address
	syscall
	
	li $v0, 8
	la $a0, addressBuffer
	li $a1, 50
	syscall
	
	li $v0, 4
	la $a0, language
	syscall
	
	li $v0, 8
	la $a0, langBuffer
	li $a1, 50
	syscall
	
	li $v0, 4
	la $a0, newln
	syscall
	
	li $v0, 4
	la $a0, nameGreet
	syscall
	
	li $v0, 4
	la $a0, nameBuffer
	syscall
	
	li $v0, 10         
    	syscall
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	