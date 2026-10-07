org 0x7C00
bits 16

start:
	xor ax, ax
	mov ds, ax
	mov ss, ax
	mov sp, 0x7C00
	
	mov si, msg
	call print
	call key_echo
	jmp $

print:
	lodsb
	or al, al
	jz .back
	
	mov ah, 0x0E
	int 0x10
	jmp print
.back:
	ret

key_echo:
	mov ah, 0x00
	int 0x16
	cmp al, 0x0D
	je .back
	
	mov ah, 0x0E
	int 0x10
	jmp key_echo
.back:
	ret

msg db "Hello, I control the computer", 0

times 510-($-$$) db 0
dw 0xAA55
