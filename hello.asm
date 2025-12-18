global main

section .text

main:
    mov rax, 1          ; syscall write
    mov rdi, 1          ; stdout
    mov rsi, msg        ; message address
    mov rdx, len        ; message size
    syscall

    mov rax, 60         ; syscall exit
    xor rdi, rdi
    syscall

section .data
msg db "Hello ASM", 10
len equ $ - msg
