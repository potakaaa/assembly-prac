.data 
	txt: .asciiz "Hello World!"

.text

	li $v0, 4
	la $a0, txt
	syscall