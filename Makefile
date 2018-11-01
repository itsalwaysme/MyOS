all: kernel os.img

release: all
debug: all
 
os.img: BOOTX64.EFI
	dd if=/dev/zero of=os.img bs=512 count=8192
	mkfs.vfat -F12 os.img
	mmd -i os.img ::/EFI
	mmd -i os.img ::/EFI/BOOT
	mcopy -i os.img BOOTX64.EFI ::/EFI/BOOT
	
BOOTX64.EFI: src/kernel.elf grub.cfg
	grub-mkstandalone --locales 'en_GB' --modules 'normal multiboot2 efi_gop efi_uga' --install-modules 'normal multiboot2 efi_gop efi_uga' -O x86_64-efi -o BOOTX64.EFI "boot/grub/grub.cfg=grub.cfg" "kernel/kernel.elf=src/kernel.elf"

.PHONY: kernel
kernel:
	cd src && $(MAKE) -f Makefile $(MAKECMDGOALS)

.PHONY: clean
clean:
	cd src && $(MAKE) -f Makefile $(MAKECMDGOALS)
	rm -f BOOTX64.EFI
	rm -f os.img


