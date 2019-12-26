section .data
msg db "helloworld!",0xA
len equ $-msg

section .text
global _start
_start:
mov rax,01
mov rdi,01
mov rsi,msg
mov rdx,len
syscall

mov rax,60
mov rdi,00
syscall

