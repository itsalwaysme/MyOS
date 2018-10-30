ENTRY(_start32)

KERNEL_LMA = 2M;
KERNEL_VMA = 0xFFFFFFFF80000000;

SECTIONS
{
  . = KERNEL_LMA;
  _kernel_physical_start = .;

  .boot_multiboot ALIGN(4K) :
  {
    */boot/**/boot.o (.multiboot)
  }

  .boot_text ALIGN(4K) :
  {
    */boot/**/boot.o (.text)
  }

  .boot_data ALIGN(4K) :
  {
    */boot/**/boot.o (.data)
  }

  .boot_bss ALIGN(4K) :
  {
    */boot/**/boot.o (COMMON)
    */boot/**/boot.o (.bss)
  }

  . += KERNEL_VMA;
  _kernel_virtual_start = .;

  .text ALIGN(4K) : AT(ADDR(.text) - KERNEL_VMA)
  {    
    *(.text)
  }

  .rodata ALIGN(4K) : AT(ADDR(.rodata) - KERNEL_VMA)
  {
    *(.rodata*)
  }

  .data ALIGN(4K) : AT(ADDR(.data) - KERNEL_VMA)
  {
    *(.data)
  }

  .eh_frame ALIGN(4K) : AT(ADDR(.eh_frame) - KERNEL_VMA)
  {
    _ehframe = .;
    *(.eh_frame)
  }

  .bss ALIGN(4K) : AT(ADDR(.bss) - KERNEL_VMA)
  {
    *(COMMON)
    *(.bss)
  }

  _kernel_virtual_end = .;
  _kernel_physical_end = . - KERNEL_VMA;

  /DISCARD/ :
  {
    *(.comment)
  }
}