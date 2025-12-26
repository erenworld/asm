global strlen

section .text
  strlen:
    xor rcx, rcx    ; xor = OR exclusif  0,0=0  1,0=1  1,1=0   rcx XOR rcx  met le flag 
  
  .loop:            ; un label
    cmp byte [rdi + rcx], 0
    je .end             ; saute si ZF = 1 (égal)
    inc rcx
    jmp .loop

  .end:
    mov rax, rcx
    ret
