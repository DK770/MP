section .data
xyz db 45h,0xA
;hahaha

section .text
global _start
_start:
mov rax,01
mov rdi,01
mov rsi,xyz
mov rdx,2
syscall

mov rax,60
mov rdi,00
syscall
