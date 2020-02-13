;Write X86/64 ALP to perform non-overlapped and overlapped
;block transfer (with and without string specificWrite X86/64 ALP to 
;containing data can be defined in the data segment.

%macro print 2
     mov rax,1
     mov rdi,1
     mov rsi,%1
     mov rdx,%2
     syscall
%endmacro

%macro scall 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

section .data
     array dq 0010,0026,0041,0079,0080,0000,0000,0000,0000,0000,0000
     size db 05h
     cnt1 db 0Ah
     cnt2 db 0Ah
     new db 0xA
     msg1 db 'VALUES in array before copying: '
	len1 equ $-msg1
	msg2 db 'VALUES in array after copying: '
	len2 equ $-msg2
	msg3 db 'MENU',10
	len3 equ $-msg3
	msg4 db '1.Non-overlapping data transfer',10
	len4 equ $-msg4
	msg5 db '2.Overlapping data transfer',10
	len5 equ $-msg5
	msg6 db '3.Non-overlapping data transfer(with string instruction)',10
	len6 equ $-msg6
	msg7 db '4.Overlapping data transfer(with string instruction)',10
	len7 equ $-msg7
	msg8 db 'Enter option '
	len8 equ $-msg8
	msg9 db 'How many bytes do you want to overlap	'
	len9 equ $-msg9
	
section .bss
	result resq 1
	tot resb 16
	option resb 5
	over resb 5
	ans resw 5
	
	
section .text
	global _start
_start:
	print msg1,len1
	print new,1
	 		
	mov rbx,array
	up:	
		mov rcx,qword[rbx]
		push rbx
		call _hex_to_ascii
		print new ,1
		pop rbx
		add rbx,08h
		dec byte[cnt1]
		jnz up
		
print msg9,len9
		scall 0,0,over,2
		xor rbx,rbx
		xor rax,rax
		xor rcx,rcx
		mov bl,byte[over]
		sub bl,30h
		mov cl,05h
		sub cl,bl
		mov al,08h
		mul cl
		;mov word[ans],ax
		
		mov rcx,06h
		mov rsi,array+40
		mov rdi,array+40
		add rdi,rax
		std
		rep movsq

		mov rbx,array
		up4:	
			mov rcx,qword[rbx]
			push rbx
			call _hex_to_ascii
			print new,1
			pop rbx
			add rbx,08h
			dec byte[cnt2]
			jnz up4
	
	mov rax,60
	mov rdi,0
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
