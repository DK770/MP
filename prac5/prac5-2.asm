%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro accept 2
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .data
	spacemsg db 10,13,"Spaces = "
	spacemsg_len equ $-spacemsg

	newlinemsg db  10,13, "Return(Enter) chars = "
	newlinemsg_len equ $-newlinemsg

	chms db 10,13,"Character count: "
	chms_len equ $-chms

	chinput db 10,13,"Character Input: ",
	chinput_len equ $-chinput

	scnt db 00H
	ncnt db 00H
	chcnt db 00H
	hexcnt2 db 00H

section .bss
	extern cnt1,cnt2,cnt3,buffer,bufferlen
	spacecount resb 2
	ch1 resb 2
	newlinecount resb 2
	chcount resb 2

section .text
	global _start1
	global CSPACE, CNEWLINE,CCHAR
	_start1:

CSPACE:
	mov rsi,buffer
up:
	mov al,byte[rsi]
	cmp al,20H
	je next2
	inc rsi
	dec qword[cnt1]
	jnz up
	jmp next3

next2:
	inc byte[scnt]
	inc rsi
	dec qword[cnt1]
	jmp up
next3:
	mov bl, byte[scnt]
	mov rdi, spacecount
	call HtoA

	print spacemsg,spacemsg_len
	print spacecount,2

	ret

CNEWLINE:
	mov rsi,buffer
up2:
	mov al,byte[rsi]
	cmp al,0x0A
	je next4
	inc rsi
	dec qword[cnt2]
	jnz up2
	jmp next5

next4:
	inc byte[ncnt]
	inc rsi;
	dec qword[cnt2]
	jnz up2

next5:
	mov bl, byte[ncnt]
	mov rdi, newlinecount
	call HtoA
	
	print newlinemsg,newlinemsg_len
	print newlinecount,2

	ret

CCHAR:
	print chinput,chinput_len
	accept ch1,2
	mov rsi,buffer
up3:
	mov al,byte[rsi]
	cmp al,byte[ch1]
	je nextl
	inc rsi
	dec qword[cnt3]
	jnz up3
	jmp next7
nextl:
	inc byte[chcnt]
	inc rsi;
	dec qword[cnt3]
	jnz up3

next7:
	mov bl, byte[chcnt]
	mov rdi, chcount
	call HtoA
	print chms,chms_len
	print chcount,2

ret

;------HEX TO ASCII CONVERSION METHOD FOR VALUE(2 DIGIT) ----------------

HtoA:             ;hex_no to be converted is in ebx //result is stored in rdi/user defined variable
	mov byte[hexcnt2],02H

h2aup:
	rol bl,04
	mov cl,bl
	and cl,0FH
	CMP CL,09H
	jbe add30
	ADD cl,07H

add30:
	add cl, 30H
	mov byte[rdi],cl
	INC rdi
	dec byte[hexcnt2]
	JNZ h2aup
	ret

exit:
	mov rax,60
	mov rdi,0
	syscall
