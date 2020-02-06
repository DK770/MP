;Write X86/64 ALP to count number of positive and negative numbers from the array.

section .data
	msg db " ",0xA
	len equ $-msg
	array db 70h, 75h, 80h, 85h, 90h
	cnt db 5
	neg db 0
	pos db 0

section .text
	global _start
	
	_start:
	mov rsi,array
	
	loop:
	mov al,byte[rsi]
	add al,0h
	js point1		;jump if sign
	inc byte[pos]
	jmp point2		;jump
	
	point1:
	inc byte[neg]
	
	point2:
	inc byte[rsi]
	dec byte[cnt]
	jnz loop		;jump if nonzero
	
	mov rax,01
	mov rdi,01
	mov rsi,pos
	mov rdx,1
	syscall
	
	mov rax,01
	mov rdi,01
	mov rsi,neg
	mov rdx,1
	syscall
	
	mov rax,01
	mov rdi,01
	mov rsi,msg
	mov rdx,len
	syscall
	
	mov rax,60		;exit
	mov rdi,00
	syscall
	
