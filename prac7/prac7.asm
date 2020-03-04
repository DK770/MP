%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro file 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

Section .data
	openmsg db 10,13,"File Opened Successfully"
	openmsg_len equ $-openmsg

	closemsg db 10,13,"File Closed Successfully"
	closemsg_len equ $-closemsg

	errormsg db 10,13,"Failed to open file", 0xa
	errormsg_len equ $-errormsg

	space db " "
	space_len equ $ - space

	sortmsg db 10,13,"After Sorting "
	sortmsg_len equ $-sortmsg
	
	newline db "",0xA
	newlinelen equ $-newline

	f1name db 'input.txt'

Section .bss
	buffer resb 200
	bufercpy resb 200
	bufferlen resb 8
	cnt1 resb 8
	cnt2 resb 8
	fdisplay resb 8

Section .text
	global _start
	_start:

	file 2, f1name, 2, 777      ;Opening file

	mov qword[fdisplay], rax      ;RAX contains file descriptor value
	bt rax, 63             ;63rd bit is +ve(0) if file is successfull opened else it is -ve (1)
		                ;Here we are checking for MSB if MSB is 1 that means -ve and if MSB is 0 that means +ve
	jc ERROR

	print openmsg, openmsg_len
	jmp next1

	ERROR:
	print errormsg, errormsg_len
	jmp EXIT

	next1:
	file 0,[fdisplay] ,buffer,200     ;reading contents of file in buffer
		             ;rax contains actual number of bytes read
	mov qword[bufferlen],rax         ;for rounds
	mov qword[cnt1],rax
	mov qword[cnt2],rax


BUBBLE:
	mov al,byte[cnt2]
	mov byte[cnt1],al
	dec byte[cnt1]

	mov rsi,buffer
	mov rdi,buffer+1

	loop:
	mov bl,byte[rsi]
	mov cl,byte[rdi]
	cmp bl,cl
	jb SWAP		;for descending order
	;ja SWAP		;for ascending order
	inc rsi
	inc rdi
	dec byte[cnt1]
	jnz loop
	dec byte[bufferlen]
	jnz BUBBLE
	jmp END
SWAP:
	;mov al,byte[rsi]
	mov byte[rsi],cl
	mov byte[rdi],bl
	inc rsi
	inc rdi
	dec byte[cnt1]
	jnz loop
	dec byte[bufferlen]
	jnz BUBBLE

END:
	print sortmsg,sortmsg_len
	print buffer,qword[cnt2]

	file 1,qword[fdisplay],sortmsg,sortmsg_len      ;writing to input.txt
	file 1,qword[fdisplay],buffer,qword[cnt2]          ;writing to input.txt

	;Closing file2

	mov rax,3
	mov rdi,f1name
	syscall

	print closemsg,closemsg_len
	print newline,newlinelen

EXIT:
	mov rax,60
	mov rdi,0
	syscall
