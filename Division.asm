.data
	newLn: .asciiz "\n"
	welcomeMsg: .asciiz "Division: Helbiro and Naldoza"
	enterMember1: .asciiz "Enter Member 1 Name: "
	enterMember2: .asciiz "Enter Member 2 Name: "
	member1Input: .space 30
	member2Input: .space 30
	
	enterNumber1: .asciiz "Enter First Number: "
	enterNumber2: .asciiz "Enter Second Number: "
	
	div: .asciiz " ÷ "
	is: .asciiz " is "
	
.text

	li $v0, 4		# operation to print string
	la $a0, welcomeMsg	# print welcome msg variable
	syscall
	
	li $v0, 4		# operation to print string
	la $a0, newLn		# print new line
	syscall
	
	li $v0, 4
	la $a0, enterMember1
	syscall
	
	li $v0, 8		# operation to read string
	la $a0, member1Input	# store input to member input1 variable
	li $a1, 30
	syscall
	
	li $v0, 4
	la $a0, enterMember2
	syscall
	
	li $v0, 8
	la $a0, member2Input
	li $a1, 30
	syscall
	
	li $v0, 4
	la $a0, newLn
	syscall
	
	li $v0, 4		# operation to print string
	la $a0, enterNumber1	# print prompt
	syscall
	
	li $v0, 5		# operaton to read integer
	syscall
	move $t0, $v0		# store input to $t0

	li $v0, 4
	la $a0, enterNumber2
	syscall
	
	li $v0, 5		# operaton to read integer
	syscall
	move $t1, $v0		# store input to $t1
	
	li $v0, 4
	la $a0, newLn
	syscall
	
	move $a0, $t0		# move $t0 to $a0 to print it
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, div		
	syscall
	
	move $a0, $t1		# move $t1 to $a0 to print it
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, is
	syscall
	
	li $v0, 1
	div $a0, $t0, $t1	# divide $t0 and $t1
	syscall
	
	
	
	
	
	
	
	
