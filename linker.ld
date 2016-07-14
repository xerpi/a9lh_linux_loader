OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)

ENTRY(_start)

SECTIONS
{
	. = 0x23F00000;
	.text.start : { *(.text.start ) }
	.text       : { *(.text) }
	.rodata     : { *(.rodata) *(.rodata*) }
	.data       : { *(.data) }
	.bss        : { *(.bss COMMON) }
	. = ALIGN(4);
	__end__ = ABSOLUTE(.);
}
