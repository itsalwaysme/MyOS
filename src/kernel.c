#include <stdbool.h>
#include <stdint.h>
#include "klibc/include/stdio.h"
#include "klibc/include/string.h"
#include "arch/x86_64/serial/include/serial.h"

// TODO need my own header file

// TODO benchark O2 vs O3

void init_cpu() {
    // TODO init CPU cr0 cr4 cr8 xcr0 efer .etc
}

void init_framebuffer() {
    //TODO get struct from multiboot info
    //TODO can we check memory map to see if memory is write combining and set it so for framebuffer?
}

void init_memory() {

}

void init_acpi() {

}

void kernel_main(uintptr_t* multiboot) {

    init_serial();
    char stringa[50];
    snprintf(stringa, sizeof(stringa), "Multiboot pointer: 0x%p", multiboot);
    write_serial(stringa);

    init_cpu();
    init_memory();    

	while(true);
}