; Accepts a pointer to a null-terminated string and prints it to stdout.

global _start

section .data
msg: db "Hello", 10

section .text
  _start:
    ; write
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, 6
    syscall

    mov rax, 60
    mov rdi, 0
    syscall
