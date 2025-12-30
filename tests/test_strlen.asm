global _start
extern strlen

section .data
    s db "hello", 0

section .text
_start:
    mov rdi, s
    call strlen

    mov rdi, rax
    mov rax, 60
    syscall

