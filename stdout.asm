; string_length Accepts a pointer to a string and returns its length.

; write = 1
; rdi -> fd (stdout=1)
; rsi -> addresse du buffer
; rdx -> nb octets à écrire

global _start

section .data
msg: db 'A'       ; msg addresse, A = 1 octet

section .text
   _start:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg  ; copie l'addresse de msg dans rsi
    mov rdx, 1
    syscall

    ; exit properly
    mov rax, 60
    mov rdi, 0
    syscall

