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

Section .data
	title db 10,13,"****ASSIGNMENT: 5****"
	title_len equ $-title
	openmsg db 10,13,"File Opened Successfully"
	openmsg_len equ $-openmsg
	errormsg db 10,13,"Failed to open file"
	errormsg_len equ $-errormsg
	newline db " ",0xA
	newlinelen equ $-newline

	fname db "abc.txt"

Section .bss
	global cnt1,cnt2,cnt3,buffer,bufferlen,fdis
	cnt1 resb 8
	cnt2 resb 8
	cnt3 resb 8
	bufferlen resb 8
	buffer resb 200
	fdis resq 1                     ;for storing file descriptor value

Section .text
	global _start
	extern CSPACE,CNEWLINE,CCHAR
	start:
	;print title,title_len

	;Opening file
	mov rax,2
	mov rdi,fname
	mov rsi,2
	mov rdx,777
	syscall

	mov qword[fdis],rax            ;RAX contains file descriptor value
	bt rax,63                      ;63rd bit is +ve(0) if file is successfull opened else it is -ve (1)
	jc next

	print openmsg,openmsg_len
	jmp next1

next:
	print errormsg,errormsg_len
	jmp EXIT

next1:
	;reading contents of file in buffer
	mov rax,0
	mov rdi,[fdis]
	mov rsi,buffer
	mov rdx,200
	syscall
                                ;rax contains actual number of bytes read
	mov qword[bufferlen],rax
	mov qword[cnt1],rax             ;cnt1 for using in cspace procedure
	mov qword[cnt2],rax             ;cnt2 for using in cnewline procedure
	mov qword[cnt3],rax             ;cnt3 for using in cchar procedure

	call CCHAR
	call CSPACE
	call CNEWLINE
	print newline,newlinelen

	mov rax,3
	mov rdi,fname
	syscall

EXIT:
	mov rax,60
	mov rdi,0
	syscall
