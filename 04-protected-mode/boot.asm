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
	
	;复位
	mov ah, 0x00
	int 0x13

	;读磁盘
	mov ah, 0x02
	;al读几个扇区，ch柱面号，cl扇区号，dh磁头，dl保持开机驱动器号
	mov al, 1
	mov ch, 0
	mov cl, 2
	mov dh, 0
	
	xor bx, bx
	mov es, bx
	mov bx, 0x7E00
	int 0x13
	jc error

	jmp 0x0000:0x7E00
printc:
	mov ah, 0x0E
	int 0x10
	ret
error:
	mov si, err_msg
	call print
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
	mov al, 0x0D
	call printc
	mov al, 0x0A
	call printc
	ret

msg db "Hello, I control the computer!", 0
err_msg db "Disk error!", 0

times 510-($-$$) db 0
dw 0xAA55
