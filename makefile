# Makefile pour le bootloader simple

ASM = nasm
QEMU = qemu-system-i386

# Cibles par défaut
all: bootloader.bin kernel.bin os-image.bin

# Compiler le bootloader
bootloader.bin: bootloader.asm
	$(ASM) -f bin bootloader.asm -o bootloader.bin

# Compiler le kernel
kernel.bin: kernel.asm
	$(ASM) -f bin kernel.asm -o kernel.bin

# Créer l'image complète du système
os-image.bin: bootloader.bin kernel.bin
	cat bootloader.bin kernel.bin > os-image.bin

# Tester avec QEMU
test: os-image.bin
	qemu-system-i386 -drive format=raw,file=os-image.bin -nographic -serial mon:stdio


# Créer une disquette virtuelle (optionnel)
floppy: os-image.bin
	dd if=/dev/zero of=floppy.img bs=1024 count=1440
	dd if=os-image.bin of=floppy.img conv=notrunc

# Nettoyer les fichiers générés
clean:
	rm -f *.bin *.img

# Installer sur une vraie clé USB (ATTENTION: remplacer /dev/sdX)
# install: os-image.bin
#	sudo dd if=os-image.bin of=/dev/sdX bs=512

.PHONY: all test clean floppy