%macro sycall 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

section .data
	num1 db 0xC
	num2 db 04h
	msg1 db "multiplying decimal no.s 12 & 4, expected output=48(dec) or 30h(hex):",0Ah
	len1 equ $-msg1
	

section .bss
	ans resb 4
	cntr2 resb 4

section .text
	global _start
	
	_start:
	sycall 1,1,msg1,len1
	;mov byte[ans],0h
	mov al,0h
	
	succ:
		add al,byte[num1]
		dec byte[num2]
		jnz succ
	
	;mov byte[ans],al
	call _hex_to_ascii
	
	mov rax,60		;end program
	mov rdx,00
	syscall
	
_hex_to_ascii:
	mov rbx,ans
    	mov byte[cntr2],4
	
	label1:
		rol rcx,04                   
		mov dl,cl                       
		and dl,0Fh
		cmp dl,09h
		jbe lb1
		add dl,07h
	lb1:
		add dl,30h
		mov byte[rbx],dl       
		inc rbx
		dec byte[cntr2]
		jnz label1  
		sycall 1,1,ans,4   
   	ret

; Write X86/64 ALP to perform multiplication of two 8-bit
; hexadecimal numbers. Use successive addition and add and shift
; method. (use of 64-bit registers is expected) .


