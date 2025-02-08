.data
	name: .asciiz "What's your name? "
	age: .asciiz "How old are you? "
	address: .asciiz "Where do you live? "
	language: .asciiz "What's your favorite programming language? "
	nameGreet: .asciiz "Your name is "
	ageGreet: .asciiz "You are "
	addGreet: .asciiz "You live in "
	langGreet: .asciiz "You love coding in "
	
	newln: .asciiz "\n"
	nameBuffer: .space 50
	addressBuffer: .space 50
	langBuffer: .space 50
	
.text
	# name input
	li $v0, 4
	la $a0, name
	syscall
	
	# read name as string and store on name buffer
	li $v0, 8
	la $a0, nameBuffer
	li $a1, 50
	syscall
	
	# age input
	li $v0, 4
	la $a0, age
	syscall
	
	# read age as integer
	li $v0, 5
	syscall
	move $t0, $v0
    	
    	# address input
    	li $v0, 4
	la $a0, address
	syscall

    	# read address as string	
	li $v0, 8
	la $a0, addressBuffer
	li $a1, 50
	syscall
	
    	# langguage input
	li $v0, 4
	la $a0, language
	syscall
	
    	# read language input
	li $v0, 8
	la $a0, langBuffer
	li $a1, 50
	syscall
	
	li $v0, 4
	la $a0, newln
	syscall
	
    	# print greet name 
	li $v0, 4
	la $a0, nameGreet
	syscall
	
    	# print name
	li $v0, 4
	la $a0, nameBuffer
	syscall
	
	li $v0, 4
	la $a0, newln
	syscall
	
	li $v0, 4
	la $a0, ageGreet
	syscall
	
	li $v0, 1
	move $a0, $t0
	syscall
	
	li $v0, 4
	la $a0, newln
	syscall
	
	li $v0, 4
	la $a0, addGreet
	syscall
	
	li $v0, 4
	la $a0, addressBuffer
	syscall
	
	li $v0, 4
	la $a0, newln
	syscall
	
	li $v0, 4
	la $a0, langGreet
	syscall
	
	li $v0, 4
	la $a0, langBuffer
	syscall

	
	li $v0, 10         
    	syscall
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
