# Bootloader Simple Linux

Un projet éducatif pour créer un bootloader minimal en Assembly x86 qui charge et exécute un kernel simple.

## 🎯 Objectif

Ce projet vous permet d'apprendre :
- Le fonctionnement d'un bootloader
- La transition du mode 16-bit vers 32-bit
- La programmation Assembly bas niveau
- Le processus de boot d'un système d'exploitation

## 📁 Structure du projet

```
simple-bootloader/
├── bootloader.asm      # Code du bootloader principal
├── kernel.asm          # Code du kernel simple
├── Makefile           # Script de compilation
└── README.md          # Ce fichier
```

## 🔧 Prérequis

### Ubuntu/Debian
```bash
sudo apt update
sudo apt install nasm qemu-system-i386 build-essential
```

### Fedora/CentOS
```bash
sudo dnf install nasm qemu-system-i386 make gcc
```

### Arch Linux
```bash
sudo pacman -S nasm qemu-system-i386 make gcc
```

## 🚀 Installation et compilation

1. **Cloner ou créer le projet**
```bash
mkdir simple-bootloader
cd simple-bootloader
```

2. **Créer les fichiers** (bootloader.asm, kernel.asm, Makefile)

3. **Compiler le projet**
```bash
make all
```

4. **Tester dans l'émulateur**
```bash
make test
```

## 📋 Commandes disponibles

| Commande | Description |
|----------|-------------|
| `make all` | Compile le bootloader et le kernel |
| `make test` | Lance le système dans QEMU |
| `make clean` | Supprime les fichiers générés |
| `make floppy` | Crée une image disquette virtuelle |

## 🔍 Fonctionnement détaillé

### Phase 1 : Bootloader (bootloader.asm)
- **Initialisation** : Configure les segments en mode 16-bit
- **Affichage** : Montre un message de bienvenue via BIOS
- **Chargement** : Lit le kernel depuis le secteur 2 du disque
- **Mode protégé** : Configure la GDT et passe en 32-bit
- **Saut** : Transfert le contrôle au kernel

### Phase 2 : Kernel (kernel.asm)
- **Affichage vidéo** : Accès direct à la mémoire vidéo (0xB8000)
- **Message** : Affiche un texte coloré confirmant le chargement
- **Boucle** : Entre dans une boucle infinie avec instruction HLT

## 🛠️ Personnalisation

### Modifier les messages
```assembly
welcome_msg db 'Votre message ici', 0xD, 0xA, 0
kernel_msg db 'Votre kernel personnalise!', 0
```

### Changer les couleurs
```assembly
mov ah, 0x02    ; 0x02 = vert sur noir
                ; 0x04 = rouge sur noir
                ; 0x0F = blanc sur noir
```

### Ajouter des fonctionnalités
- Détection du clavier
- Menu de sélection
- Chargement depuis USB
- Gestion de la mémoire

## ⚠️ Installation sur matériel réel

**ATTENTION** : Cette opération peut endommager votre système !

```bash
# Identifier votre clé USB (remplacer X par la bonne lettre)
lsblk

# Écrire l'image (TRÈS DANGEREUX)
sudo dd if=os-image.bin of=/dev/sdX bs=512
```

## 🐛 Dépannage

### Erreur de compilation
```bash
# Vérifier que nasm est installé
nasm --version

# Nettoyer et recompiler
make clean
make all
```

### QEMU ne démarre pas
```bash
# Installer les dépendances manquantes
sudo apt install qemu-system-i386

# Tester avec des options de debug
qemu-system-i386 -fda os-image.bin -monitor stdio
```

### Le bootloader ne s'affiche pas
- Vérifier que la signature 0xAA55 est présente
- S'assurer que la taille fait exactement 512 octets
- Tester dans une machine virtuelle d'abord

## 📚 Ressources pour aller plus loin

- [OSDev Wiki](https://wiki.osdev.org/) - Documentation complète
- [Intel x86 Manual](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html) - Référence officielle
- [NASM Documentation](https://nasm.us/docs.php) - Guide de l'assembleur
- [GRUB Manual](https://www.gnu.org/software/grub/manual/) - Bootloader avancé

## 🤝 Contribution

Les améliorations sont les bienvenues ! N'hésitez pas à :
- Signaler des bugs
- Proposer des fonctionnalités
- Améliorer la documentation
- Ajouter des exemples

## 📄 Licence

Ce projet est à des fins éducatives. Libre d'utilisation et de modification.

## 🏁 Étapes suivantes

Une fois ce projet maîtrisé, vous pouvez explorer :
- **Bootloader avancé** : Menu multi-boot, chargement ELF
- **Kernel C** : Réécrire le kernel en C
- **Drivers** : Clavier, souris, réseau
- **Système de fichiers** : FAT32, ext2
- **Multitâche** : Ordonnanceur, processus
- **Interface graphique** : Mode VESA, fenêtres

Bon développement ! 🚀
