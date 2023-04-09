X86_64_ASM_SOURCES := $(shell find src/impl/x86_64 -name *.asm)
X86_64_ASM_OBJECTS := $(patsubst src/impl/x86_64/%.asm, build/x86_64/%.o, $(X86_64_ASM_SOURCES))

X86_64_C_SOURCES := $(shell find src/impl/x86_64 -name *.c)
X86_64_C_OBJECTS := $(patsubst src/impl/x86_64/%.c, build/x86_64/%.o, $(X86_64_C_SOURCES))

KERNEL_C_SOURCES := $(shell find src/impl/kernel -name *.c)
KERNEL_C_OBJECTS := $(patsubst src/impl/kernel/%.c, build/kernel/%.o, $(KERNEL_C_SOURCES))

X86_64_OBJECTS := $(X86_64_C_OBJECTS) $(X86_64_ASM_OBJECTS)

$(X86_64_ASM_OBJECTS): build/x86_64/%.o : src/impl/x86_64/%.asm
	mkdir -p $(dir $@)
	nasm -f elf64 $(patsubst build/x86_64/%.o, src/impl/x86_64/%.asm, $@) -o $@

$(X86_64_C_OBJECTS): build/x86_64/%.o : src/impl/x86_64/%.c
	mkdir -p $(dir $@)
	x86_64-elf-gcc -c -I src/inc -ffreestanding $(patsubst build/x86_64/%.o, src/impl/x86_64/%.c, $@) -o $@

$(KERNEL_C_OBJECTS): build/kernel/%.o : src/impl/kernel/%.c
	mkdir -p $(dir $@)
	x86_64-elf-gcc -c -I src/inc/kernel -ffreestanding $(patsubst build/kernel/%.o, src/impl/kernel/%.c, $@) -o $@

.PHONY: build-x86_64
build-x86_64: $(KERNEL_C_OBJECTS) $(X86_64_OBJECTS)
	mkdir -p dist/x86_64
	x86_64-elf-ld -n -o dist/x86_64/kernel.bin -T targets/x86_64/linker.ld $(KERNEL_C_OBJECTS) $(X86_64_OBJECTS)
	cp dist/x86_64/kernel.bin targets/x86_64/iso/boot/kernel.bin
	grub-mkrescue /usr/lib/grub/i386-pc -o dist/x86_64/CompatOS.iso targets/x86_64/iso