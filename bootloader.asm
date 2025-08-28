[BITS 16]           ; Mode 16-bit
[ORG 0x7C00]        ; Adresse de chargement du bootloader

start:
    ; Initialiser les segments
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00      ; Stack pointer

    ; Afficher le message de démarrage
    mov si, welcome_msg
    call print_string

    ; Charger le kernel depuis le disque
    mov ah, 0x02        ; Fonction lecture disque
    mov al, 1           ; Nombre de secteurs à lire
    mov ch, 0           ; Cylindre 0
    mov cl, 2           ; Secteur 2 (après le bootloader)
    mov dh, 0           ; Tête 0
    mov dl, 0x80        ; Disque dur principal
    mov bx, 0x1000      ; Adresse où charger le kernel
    int 0x13            ; Interruption BIOS disque

    jc disk_error       ; Saut si erreur

    ; Passer en mode protégé (simplifié)
    cli                 ; Désactiver les interruptions
    lgdt [gdt_descriptor]
    
    mov eax, cr0
    or eax, 1           ; Activer le bit PE (Protection Enable)
    mov cr0, eax
    
    jmp 0x08:protected_mode

disk_error:
    mov si, error_msg
    call print_string
    hlt

print_string:
    lodsb               ; Charger le caractère suivant
    or al, al           ; Test si fin de chaîne
    jz done
    mov ah, 0x0E        ; Fonction BIOS télétype
    int 0x10            ; Interruption BIOS vidéo
    jmp print_string
done:
    ret

[BITS 32]
protected_mode:
    ; Initialiser les segments en mode protégé
    mov ax, 0x10        ; Sélecteur de segment de données
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000    ; Nouveau stack pointer

    ; Sauter vers le kernel
    jmp 0x1000

; Global Descriptor Table
gdt_start:
    ; Descripteur null (obligatoire)
    dd 0x0
    dd 0x0

    ; Descripteur de code
    dw 0xFFFF           ; Limite (bits 0-15)
    dw 0x0000           ; Base (bits 0-15)
    db 0x00             ; Base (bits 16-23)
    db 10011010b        ; Flags d'accès
    db 11001111b        ; Flags + limite (bits 16-19)
    db 0x00             ; Base (bits 24-31)

    ; Descripteur de données
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10010010b
    db 11001111b
    db 0x00

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; Taille de la GDT
    dd gdt_start                ; Adresse de la GDT

; Messages
welcome_msg db 'Bootloader Simple - Chargement...', 0xD, 0xA, 0
error_msg db 'Erreur de lecture disque!', 0xD, 0xA, 0

; Remplissage et signature de boot
times 510-($-$$) db 0
dw 0xAA55               ; Signature de boot