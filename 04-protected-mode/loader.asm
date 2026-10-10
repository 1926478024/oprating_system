org 0x7E00
bits 16

start:
	xor ax, ax
	mov ds, ax
	
	cli

	;开开关(第21根地址线）
	in al, 0x92
	or al, 0x02
	out 0x92, al

	;加载gdt
	lgdt[gdt_descriptor]
	
	;置PE位并远跳转
	mov eax, cr0
	or eax, 1
	mov cr0, eax
	jmp dword CODE_SEG:protected_start

;gdt定义
gdt_start:
	;空描述符
	dd 0x00000000, 0x00000000
gdt_code:
	;定义数据，类似于C结构体
	dw 0xFFFF
	dw 0x0000
	db 0x00
	;每一位都代表一个功能，历史遗产
	db 10011010b
	db 11001111b
	db 0x00
gdt_data:
	dw 0xFFFF
	dw 0x0000
	db 0x00
	db 10010010b
	db 11001111b
	db 0x00
gdt_end:

gdt_descriptor:
	dw gdt_end - gdt_start - 1
	dd gdt_start
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start;

; -----------32位代码------------------
bits 32
protected_start:
	mov ax, DATA_SEG
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov esp, 0x90000

	;BIOS中断在保护模式下不能用了
	;直接写显存：文本模式显存固定在0xB8000,每行80个字符，+10 * 160会显示在第10行
	;每个字符占2字节：ASCII码+颜色
	mov edi, 0xB8000 + 10 * 160
	mov esi, msg
	mov ah, 0x0F

.print:
	lodsb
	test al, al
	jz .back
	
	mov [edi], al
	mov [edi+1], ah
	add edi, 2

	jmp .print
.back:
	;关中断表
	cli
	;停机指令，CPU睡觉
	hlt
	jmp .back

msg db "Stage 2 loaded! Protexted Mode! I am 32-bit now:)", 0

