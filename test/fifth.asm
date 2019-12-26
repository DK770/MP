;length of input is less than or equal to 9

section .data
	msg1 db "enter your name:- ", 0Ah
	len1 equ $-msg1
	counter db 5h

section .bss
	xyz resb 10
	len resb 10

section .text
	global _start
	
	_start:
	;requesting
	mov rax,01
	mov rdi,01
	mov rsi,msg1
	mov rdx,len1
	syscall
	
	;input name
	mov rax,00
	mov rdi,00
	mov rsi,xyz
	mov rdx,10
	syscall
	
	;length display
	dec al
	add al,30h
	mov byte[len],al
	mov rax,01
	mov rdi,01
	mov rsi,len
	mov rdx,1
	syscall

	label1:
	;name display
	mov rax,01
	mov rdi,01
	mov rsi,xyz
	mov rdx,10
	syscall
	dec byte[counter]
	jnz label1
	
	
	mov rax,60
	mov rdi,00
	syscall
	
