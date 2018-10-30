#include "boot/arch/x86_64/include/boot.h"
#include "boot/include/multiboot2.h"
#include "kernel/arch/x86_64/mmu/include/mmu.h"
#include "kernel/arch/x86_64/cpu/include/gdt.h"
#include "kernel/arch/x86_64/cpu/include/msr.h"

/*
 * Multiboot header
 */
.section .multiboot
.align 8
multiboot_header:
    .long MULTIBOOT2_HEADER_MAGIC   
    .long MULTIBOOT2_ARCHITECTURE_I386
    .long multiboot_header_end - multiboot_header
    .long -(MULTIBOOT2_HEADER_MAGIC + MULTIBOOT2_ARCHITECTURE_I386 + (multiboot_header_end - multiboot_header))
.align 8
information_request_tag_start:
    .short MULTIBOOT2_HEADER_TAG_INFO_REQUEST
    .short MULTIBOOT2_HEADER_TAG_FLAG_REQUIRED
    .long  information_request_tag_end - information_request_tag_start
    .long  MULTIBOOT2_TAG_TYPE_FRAMEBUFFER
    .long  MULTIBOOT2_TAG_TYPE_EFI_MMAP
    .long  MULTIBOOT2_TAG_TYPE_ACPI_NEW
information_request_tag_end:
.align 8
module_alignment_tag_start:
    .short MULTIBOOT2_HEADER_TAG_MODULE_ALIGN
    .short MULTIBOOT2_HEADER_TAG_FLAG_REQUIRED
    .long  module_alignment_tag_end - module_alignment_tag_start
module_alignment_tag_end:
.align 8
framebuffer_tag_start:
    .short MULTIBOOT2_HEADER_TAG_FRAMEBUFFER
    .short MULTIBOOT2_HEADER_TAG_FLAG_REQUIRED
    .long framebuffer_tag_end - framebuffer_tag_start
    .long 1024
    .long 768
    .long 32
framebuffer_tag_end:
.align 8
multiboot_header_tag_end:
    .short MULTIBOOT2_HEADER_TAG_END
    .short 0
    .long  8
multiboot_header_tag_end_end:
multiboot_header_end:

/*
 * Uninitialized data
 */
.section .bss
// Page tables
.comm pml4, PML4_SIZE, PML4_ALIGNMENT
.comm low_pdpt, PDPT_SIZE, PDPT_ALIGNMENT
.comm high_pdpt, PDPT_SIZE, PDPT_ALIGNMENT
.comm low_page_directory_table, PAGE_DIRECTORY_SIZE, PAGE_DIRECTORY_ALIGNMENT
.comm high_page_directory_table, PAGE_DIRECTORY_SIZE, PAGE_DIRECTORY_ALIGNMENT
// Super small lower stack
.align 16
stack_bottom:
	.skip 128
stack_top:
// Multiboot ptr
.align 4
multiboot_ptr:
    .skip 4

/*
 * Data
 */
.data
// GDT
.align GDT_TABLE_ALIGNMENT
gdt_table:
    .8byte 0
    .8byte GDT_KERNEL_ENTRY
gdt_table_end:
    .skip (GDT_TABLE_SIZE - (gdt_table_end - gdt_table))
gdt_ptr:
	.short GDT_TABLE_SIZE - 1
	.long gdt_table
 
/*
 * 32bit entrypoint
 */
.code32
.section .text
.global _start32
.type _start32, @function
_start32:

	// Setup stack and wipe eflags
	movl  $stack_top, %esp
    pushl $0
    popf

    // Save the multiboot info ptr
    movl %ebx, multiboot_ptr

/*
 * Setup paging
 */
setup_paging:
    movl $low_pdpt, %eax
    or   $(MMU_PRESENT | MMU_WRITABLE), %eax
    movl %eax, pml4 + (PML4_ADDR_TO_ENTRY_INDEX(KERNEL_PHYSICAL_START) * PML4_ENTRY_SIZE)

    movl $high_pdpt, %eax
    or   $(MMU_PRESENT | MMU_WRITABLE), %eax
    movl %eax, pml4 + (PML4_ADDR_TO_ENTRY_INDEX(KERNEL_VIRTUAL_START) * PML4_ENTRY_SIZE)

    movl $low_page_directory_table, %eax
    or   $(MMU_PRESENT | MMU_WRITABLE), %eax
    movl %eax, low_pdpt + (PDPT_ADDR_TO_ENTRY_INDEX(KERNEL_PHYSICAL_START) * PDPT_ENTRY_SIZE)

    movl $high_page_directory_table, %eax
    or   $(MMU_PRESENT | MMU_WRITABLE), %eax
    movl %eax, high_pdpt + (PDPT_ADDR_TO_ENTRY_INDEX(KERNEL_VIRTUAL_START) * PDPT_ENTRY_SIZE)
    mov  $0, %ecx
    movl $_kernel_physical_end, %esi
    shrl $21, %esi
    addl $1, %esi
	page_directory_table_loop:
	    movl $0x200000, %eax
	    mul  %ecx
	    or   $(MMU_PRESENT | MMU_WRITABLE | MMU_PDE_TWO_MB), %eax
	    movl %eax, low_page_directory_table(, %ecx, PAGE_DIRECTORY_ENTRY_SIZE)
	    movl %eax, high_page_directory_table(, %ecx, PAGE_DIRECTORY_ENTRY_SIZE)
	    inc  %ecx
	    cmp  %esi, %ecx
	    jne  page_directory_table_loop

/*
 * Setup long mode
 */
setup_long_mode:
    movl $pml4, %eax
    movl %eax,  %cr3

    // Enable PAE
    movl $(CR4_PHYSICAL_ADDRESS_EXTENSION), %eax
    movl %eax, %cr4

    // Enable long mode in EFER
    movl $MSR_EFER, %ecx
    rdmsr
    or   $MSR_EFER_LME, %eax
    wrmsr

    // Enable paging and protected mode
    movl $(CR0_PAGE | CR0_PROTECTED_MODE_ENABLED), %eax
    movl %eax, %cr0

    lgdt gdt_ptr
    ljmp $(1 * GDT_ENTRY_SIZE), $long_mode

/*
 * 64bit long mode entry point
 */
.code64
long_mode:	
	// Setup segment selectors
    movw $0, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw %ax, %ss

/*
 * Initialize and/or reset extra instruction sets
 * Turn on/reset all known available SIMD instruction sets.
 * So kernel itself can be compiled to use these if needed.
 */
 init_fpu:
    // Set FPU control flags and reset FPU control word
    mov  %cr0, %eax
    or   $(CR0_MP | CR0_NE | CR0_EXTENSION_TYPE), %eax
    mov  %eax, %cr0
    fninit

init_sse:
    // Init SSE
    mov  %cr4, %eax
    or   $(CR4_OSXMMEXCPT | CR4_OSFXSR), %eax
    mov  %eax, %cr4

init_xsave:
    // Enable XSAVE if available (required for AVX instructions to even run)
    movl $1, %eax
    cpuid
    test $(1 << 26), %ecx
    jz   no_xsave
        // Enable XSAVE
        mov  %cr4, %eax
        or   $(CR4_OSXSAVE), %eax
        mov  %eax, %cr4
        // Enable FPU and SSE save for XSAVE
        xor  %rcx, %rcx
        xgetbv
        or   $(XCR0_X87 | XCR0_SSE), %eax
        xsetbv
    no_xsave:

init_avx:
    // Check for AVX+XSAVE and enable if available
    movl $1, %eax
    cpuid
    test $(1 << 28), %ecx // TODO cpuid header file?
    jz   no_avx        
        // Enable AVX XSAVE bits (required for AVX instructions to run)
        xor  %rcx, %rcx
        xgetbv
        or   $(XCR0_AVX), %eax
        xsetbv
        init_avx_512:
            // Check for AVX-512
            movl  $0xD, %eax
            movl  $0, %ecx
            cpuid
            test $(1 << 5 | 1 << 6 | 1 << 7), %eax
            jz   no_avx_512
                // Enable AVX-512 XSAVE bits which means instructions can be run without exception
                xor %rcx, %rcx
                xgetbv
                or  $(XCR0_OPMASK | XCR0_ZMM_Hi256 | XCR0_Hi16_ZMM), %eax
                xsetbv
            no_avx_512:
    no_avx:    

/*
 * Jump to boot trampoline in upper memory
 */
call_trampoline:
    movl   multiboot_ptr, %edi
    add    $_kernel_virtual_start, %rdi
    movabs $_start64, %rax
    jmp    *%rax
