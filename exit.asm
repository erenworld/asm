; Accepts an exit code and terminates current process

; kernel load the binary
; then it place the in the CPU at the address of _start

global _start

section .data

section .text:
  _start:
    mov rax, 60
    mov rdi, 0
    syscall

; syscall is a special convention in ABI
; rax : numéro du syscall, exit = 60
; rdi : argument 1
; rsi : argument 2
; rdx : argument 3
; (les suivants existent mais pas utiles ici)

; syscall ne prend aucun argument.
; elle lit l’état des registres
; si les registres ne sont pas préparés avant
; le kernel reçoit n’importe quoi

; mov = copie binaire de bits
; mov dest, src
; copie exactement ces bits là-bas
