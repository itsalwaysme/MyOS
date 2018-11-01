/*
 * 64bit upper stack
 */
.section .bss
.align 16
stack_bottom:
	.skip 16384
stack_top:

/*
 * 64bit upper entrypoint
 */
.code64
.section .text
.global _start64
_start64:

	// Load upper stack
	movabs $stack_top, %rsp
 
	// Enter kernel, args already in rdi .etc
	call kernel_main
 
    // Halt
	cli
1:	hlt
	jmp  1b
	