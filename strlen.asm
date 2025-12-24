global _start     ;  rend start visible pour le linker sur linux x86/64 cest _start 
                  ;  Le CPU commencera exactement à l’adresse de _start

; données statiques 
section .data     ; lisible et modifiable
                  ; Chargée en mémoire avant l’exécution
                  ; CPU n'execute pas 
test_string: db "abcdef", 0   ; label - 61 62 63 64 65 66 00 

; code executable
section .text
strlen:                     ; label, addresse dans la section .text   strlen = 0x401020
    xor rax, rax            ; instruction qui met rax a 0, sans ça -> index aléatoire
  .loop:                    ; label = address, jmp l'utilise
    cmp byte [rdi+rax], 0   ; rdi+rax = debut de la chaine [rdi + rax] = string[rax] -> l’arithmétique d’adresses
                            ; byte = [rdi+rax] -> taille inconnu donc cmp exige meme taille
                            ; fait une soustraction interne, ne stocke pas le résultat, met a jour les flags
                            ; (opérande1 - opérande2)
                            ; Met à jour ZF, SF, CF, OF, etc.
    je .end                 ; Zero Flag (ZF) = 1 ->  si cmp == 0, OUI on a fini
    inc rax                 ; sinon char suivant
    jmp .loop                ; va a laddress iteration
  .end:
    ret                   ; when we hit 'ret', rax should hold return value
                          ; lit une adresse sur la pile
                          ; saute à cette adresse
   
  ; MAIN START 
  _start:                 ; le kernel place RIP à l’adresse de _start
    mov rdi, test_string  ; rdi->string address, on copie seulement son adresse
    call strlen           ; push on the stack l’adresse de l’instruction suivante
    mov rdi, rax          ; x86/64 RULE: rdi → 1er argument  rax → valeur de retour

    mov rax, 60 
    syscall               ; ret depuis _start → crash, il faut terminer avec un syscall exit

    ; strlen changes registers, so after performing call strlen the registers can change their values.
    ; strlen does not change rbx or any other callee-saved registers
