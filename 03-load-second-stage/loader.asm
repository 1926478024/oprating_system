org 0x7E00
bits 16

start:
	xor ax, ax
	mov ds, ax
	
	mov si, msg
	call print
print:
	lodsb
	or al, al
	jz .back
	
	mov ah, 0x0E
	int 0x10

	jmp print
.back:
	jmp $

msg db "Stage 2 loaded! I am the kernel now:)", 0

