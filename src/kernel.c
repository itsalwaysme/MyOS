#include "include/klibc.h"
#include <stdbool.h>

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

void kernel_main() {

  init_cpu();
  init_memory();

  volatile char test2[1000] = "a";
  memset((void*)test2, 0, sizeof(test2));

  volatile char test[] = "abc";
  memset((void*)test, 0, sizeof(test));

  // need memset/memmove/memcopy .etc
	while(true);
}