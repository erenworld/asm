global strlen

section .text
  strlen:
    xor rcx, rcx

  .loop:
    cmp byte [rdi + rcx], 0
    je .end
    inc rcx
    jmp .loop

  .end:
    mov rax, rcx
    ret
