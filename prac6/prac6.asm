%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .data

	msg1:db 'GDTR contents :',0xa
	len1:equ $-msg1

	msg2:db 'LDTR contents:',0xa
	len2:equ $-msg2

	msg3:db 'IDTR contents :',0xa
	len3:equ $-msg3

	msg4:db 'TR contents:',0xa
	len4:equ $-msg4

	msg5:db 'MSW contents:',0xa
	len5:equ $-msg5

	msg6:db 'We are in protected mode.',0xa
	len6:equ $-msg6

	msg7:db ' ',0xa
	len7:equ $-msg7

	msg8:db 'We are not in protected mode.',0xa
	len8:equ $-msg8

	msg9:db ' : ',0xa
	len9:equ $-msg9

section .bss

	gdt:resd 01
	    resw 01
	ldt:resw 01
	idt:resd 01
	    resw 01
	tr:resw 01
	msw:resw 01

	result: resw 01

section .text

	global _start
	
	_start:
	
	smsw [msw]
	sgdt [gdt]
	sldt [ldt]
	sidt [idt]
	str [tr]

	mov ax,[msw]
	bt ax,0
	jc next
	
	print msg7,len7
	print msg8,len8

	jmp exit

next:
	print msg7,len7
	print msg6,len6

;GDTR
	print msg1,len1
	 
	mov bx,word[gdt+4]
	call HtoA
	mov bx,word[gdt+2]
	call HtoA

	print msg9,len9

	mov bx,word[gdt]
	call HtoA

;LDTR
	print msg7,len7

	print msg2,len2

	mov bx,word[ldt]
	call HtoA

;IDTR
	print msg7,len7

	print msg3,len3

	mov bx,word[idt+4]
	call HtoA
	mov bx,word[idt+2]
	call HtoA

	print msg9,len9

	mov bx,word[idt]
	call HtoA

;TR
	print msg7,len7

	print msg4,len4

	mov bx,word[tr]
	call HtoA

;MSW
	print msg7,len7
	
	print msg5,len5

	mov bx,word[msw]
	call HtoA
	
	print msg7,len7

;EXIT
exit:
	mov rax,60
	mov rdi,0 
	syscall

HtoA:
	mov rcx,4
	mov rdi,result
dup1:
	rol bx,4
	mov al,bl
	and al,0fh
	cmp al,09h
	jg p3
	add al,30h
	jmp p4
p3:	add al,37h
p4:	mov [rdi],al
	inc rdi
	loop dup1

	print result,4

	ret
