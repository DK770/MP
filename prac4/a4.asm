;Problem Statement:Write X86/64 ALP to perform multiplication of two 8-bit hexadecimal numbers. Use successive addition and add and  shift method. (use of 64-bit registers is expected).

;=================================================MACROS============================================================
%macro print 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro read 2
	mov rax,0
	mov rdi,0
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

;===============================================DATA SECTION===================================================
section .data
    menu :
    	  db 10d, 13d 
    	  db 10d, 13d, "Menu", 0x0A
	  db 10d, 13d, "=========================",0x0A
    	  db "Perform Multiplication by", 0x0A
          db "1.Successive addition", 0x0A
          db "2.Add and shift method",0x0A
	  db "3.Exit",0x0A
    	  db "Enter your Choice : "
    lmenu: equ $-menu
    
    msg2: db 10d, "Enter first HEX number : "
    len2: equ $-msg2
    msg3: db 10d, "Enter second HEX number : "
    len3: equ $-msg3
    msg4: db 10d, "Product is : "
    len4: equ $-msg4

;===============================================BSS SECTION========================================================
section .bss
 
    num1 resq 3
    num2 resq 3
    result resq 4
    choice resb 2
    count resb 2
    

;===============================================TEXT SECTION=======================================================
section .txt

global _start
_start:

Menu:
    
    print menu, lmenu		;Printing menu

    read choice,02		;Reading the choice 
 
    cmp byte[choice],31H
    je case1
 
    cmp byte[choice],32H
    je case2
 
    cmp byte[choice],33H
    je case3

case1:
        call accept
        mov rbx,[num2]
        mov [count],rbx
        xor rax,rax
label1:
	add rax,[num1]
	dec byte[count]
	jnz label1
	
        mov rdx,rax
	call HtoA
 	jmp Menu
	

case2:
    call accept
    mov rax,[num1]
    mov rbx,[num2]
    mov byte[count],04h
up3:    
    add rax,rax
    rcl rbx,01
    jnc next3
    add rax,rbx
next3:
    dec byte[count]
    jnz up3
    call HtoA
    jmp Menu

case3:
    mov rax,60
    mov rdi,0
    syscall


;===============================================PROCEDURES=======================================================
accept:

    print msg2,len2
    read num1,3 
     
    xor rbx,rbx
    xor rax,rax
    mov rcx,2
    mov rsi,num1

next:				;ASCII to HEX Conversion

    rol ax,04
    mov bl,[rsi]
    cmp bl,39h
    jbe sub30
    sub bl,7h

sub30:  sub bl,30h
   
    add ax,bx   
    inc rsi   
    loop next			;Looping the number of times the value stored in rcx i.e 5 times

    mov [num1],rax
    print msg3,len3
    read num2,3 
     
    xor rax,rax
    xor rbx,rbx
    mov rcx,2
    mov rsi,num2

next2:				;ASCII to HEX Conversion

    rol ax,04
    mov bl,[rsi]
    cmp bl,39h
    jbe sub30ii
    sub bl,7h

sub30ii:  sub bl,30h
   
    add rax,rbx   
    inc rsi   
    loop next2			;Looping the number of times the value stored in rcx i.e 5 times
    
    mov [num2],rax

ret
	
HtoA:
	 mov byte[count],04
	 mov rdi,result
         xor rbx,rbx

	 
dup2:	 
         rol ax,04
	 mov dl,al
	 and dl,0fh
	 cmp dl,09h
	 jbe l2
	 add dl,07h
l2:	 add dl,30h
	 
	 mov byte[rdi],dl
	 inc rdi
	 dec byte[count]
	 jnz dup2
	     
	 print msg4,len4
         print result,4

	 ret


