[BITS 32]
[ORG 0x1000]

; Kernel simple qui affiche du texte coloré
start_kernel:
    ; Pointeur vers la mémoire vidéo
    mov edi, 0xB8000
    
    ; Effacer l'écran
    mov ecx, 80 * 25    ; 80 colonnes x 25 lignes
    mov ax, 0x0720      ; Espace blanc sur fond noir
    rep stosw
    
    ; Réinitialiser le pointeur
    mov edi, 0xB8000
    
    ; Afficher le message du kernel
    mov esi, kernel_msg
    mov ah, 0x02        ; Attribut: vert sur noir
    
print_kernel_msg:
    lodsb
    or al, al
    jz kernel_loop
    stosw               ; Écrire caractère + attribut
    jmp print_kernel_msg

kernel_loop:
    ; Boucle infinie simple
    hlt
    jmp kernel_loop

kernel_msg db 'Kernel Simple charge avec succes!', 0

; Remplir le reste du secteur
times 512-($-$$) db 0