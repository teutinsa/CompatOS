global _start

section .text
bits 32 
_start:
	mov DWORD [0xB8000], 0x2F4B2F4F
	cli
	hlt