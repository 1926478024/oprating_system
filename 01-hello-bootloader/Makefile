NASM := nasm
QEMU := qemu-system-x86_64
IMG  := boot.img

all:$(IMG)

boot.bin:boot.asm
	$(NASM) -f bin boot.asm -o boot.bin
$(IMG):boot.bin
	dd if=/dev/zero of=$(IMG) bs=512 count=2880
	dd conv=notrunc if=boot.bin of=$(IMG)
run:
	$(QEMU) -curses -drive format=raw,file=$(IMG)

clean:
	rm -f boot.bin $(IMG)
.PHONY: all run clean
