mov rax, [rbx + 4*rcx + 9] 
mov rax, [4*r9]
mov rdx, [rax + rbx]
lea rax, [rbx + rbx * 4]  ; rax = rbx * 5
add r8, [9, + rbx * 8 + 7]

; [base + index * scale + displacement]
; base: register (optional)
; index: register (opt)
; scale: 1, 2, 4, 8
; displacement: constant signed

; Everything inside [...] is an address computation, not a value.
