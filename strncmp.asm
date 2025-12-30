global strncmp

; int strncmp(const char *s1, const char *s2, size_t n);
; rdx -> n

section .text
  strncmp:
    xor rax, rax ; set result to 0

  .loop:
    test rdx, rdx  ; si n == 0, on arrête
    jz .end

    mov al, [rdi]   ; lit 1 octet de s1 et stocke dans al
    cmp cl, [rsi]   ; ne modifie pas les registres, seulement les flags
    cmp al, cl
    jne .diff       ; if not equal jmp to .diff

    test al, al     ; vérifie si al == 0
    jz .end

    dec rdx
    inc rdi
    inc rsi
    jmp .loop

  .diff:
    movzx rax, al
    movzx rcx, cl
    sub rax, rcx

  .end:
    ret

