;length of input is greater than 9

section .data
	msg1 db "enter text: ", 0Ah
	len1 equ $-msg1

section .bss
	xyz resb 100
	len resb 2
	
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
	mov rdx,100
	syscall
	
	;length display
	dec al
	cmp al,09h
	jbe x
	add al,07h
	x:add al,30h
	mov byte[len],al
	mov rax,01
	mov rdi,01
	mov rsi,len
	mov rdx,2
	syscall
	
	mov rax,60
	mov rdi,00
	syscall
