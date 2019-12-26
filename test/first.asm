section .data
msg db "helloworld!",0xA
len equ $-msg

section .text
global _start
_start:
mov eax,04H
mov ebx,01
mov ecx,msg
mov edx,len
int 80h

mov eax,01
mov ebx,00
int 80h

