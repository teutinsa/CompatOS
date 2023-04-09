global long_mode
extern kmain

section .text
bits 64
long_mode:
	mov ax, 0
	mov ss, ax
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov dword [0xB8000], 0x2F4B2F4F
	
	call kmain
	
	cli
	hlt