global strcmp

section .text
  strcmp:
    xor rax, rax  ; set result to 0

  .next_char:
    mov al, [rdi]   ; Load byte from first string
    cmp al, [rsi]   ; compare with second string first char
    jne .diff       ; if not equal jump to diff
    test al, al     ; check if we hit \0
    je .done        ; If \0, strings are equal
    inc rdi
    inc rsi
    jmp .next_char
  .diff:
    sub rax, [rsi]  ; return diff
  .end:
    reti


; Compare the characters of two strings.
; Stop when the characters differ or the null terminator (\0) is reached.
; Return: 0 if strings are equal.
; 0 if strings are equal.
; Difference of ASCII values if they differ.

