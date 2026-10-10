NASM := nasm
QEMU := qemu-system-x86_64
IMG  := boot.img

all:$(IMG)

%.bin:%.asm
	$(NASM) -f bin -o $@ $^
$(IMG):boot.bin loader.bin
	dd if=/dev/zero of=$(IMG) bs=512 count=2880
	dd conv=notrunc if=boot.bin of=$(IMG)
	dd conv=notrunc if=loader.bin of=$(IMG) seek=1
run:
	$(QEMU) -curses -drive format=raw,file=$(IMG)

clean:
	rm -f *.bin $(IMG)
.PHONY: all run clean
