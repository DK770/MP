;Write X86/64 ALP to convert 4-digit Hex number into its
;equivalent BCD number and 5-digit BCD number into its
;equivalent HEX number. Make your program user friendly to
;accept the choice from user for: (a) HEX to BCD b) BCD to HEX
;(c) EXIT. Display proper strings to prompt the user while accepting
;the input and displaying the result. (wherever necessary, use 64-bit
;registers).

%macro sycall 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

section .data
	counter db 04
	choice1 db "enter 1 for HEX to BCD conversion, 2 for BCD to HEX conversion:- ",0Ah
	len1 equ $-choice1
	option1 db "enter number for BCD to HEX conversion:- "
	len2 equ $-option1
	option2 db "enter number for HEX to BCD conversion:- "
	len3 equ $-option2
	
	
section .bss
	choice resb 2
	num resb 10
	ans resb 10
	

section .text
	global _start
	
	_start:
	sycall 1,1,choice1,len1		;show choices
	
	sycall 0,0,choice,2		;get choice
	
	cmp byte[choice],'1'
	je hex2bcd
	cmp byte[choice],'2'
	je bcd2hex
	
	hex2bcd:		;hex to bcd conversion
		sycall 1,1,option1,len2
		sycall 0,0,num,10
		
;		mov ax,byte[num]
;		mov b1,10
;		loop1:
;			xor rdx,rdx
;			div bx
;			push dx
;			
;			inc byte[counter]
;			cmp al,00h
;			jnz loop1
		
		
		
	bcd2hex:
		sycall 1,1,option2,len3
		sycall 0,0,num,10
		
		
		xor ax,ax
		xor cx,cx
		mov rbx,0xA
		loop2:
			mul bx
			mov rsi,num
			mov cl,byte[rsi]
			sub cl,30h
			mov ax,cx
			
			
			inc rsi
			dec byte[counter]
			jnz loop2
			
		call _hex_to_ascii
		
		mov word[ans],ax
		sycall 1,1,ans,4
		
	mov rax,60
	mov rdx,00
	syscall
	
_hex_to_ascii:
	mov rbx,result
    	mov byte[tot],16           
	                        
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
		dec byte[tot]
		jnz label1  
		print result,16      
   	ret
	
