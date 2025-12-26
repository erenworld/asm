extern strlen
global _start

section .data
test_string: db "hello", 0

section .text
  _start:
    mov rdi, test_string
    call strlen           ; rax longueur

    mov rdx, rax          ; taille
    mov rax, 1            ; 1 is write syscall
    mov rdi, 1            ; stdout
    mov rsi, test_string
    syscall

    mov rax, 60
    mov rdi, 0
    syscall

