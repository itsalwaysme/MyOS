#include <stdbool.h>

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

void kernel_main(char* multiboot_info) {

  init_cpu();
  init_memory();

  // need memset/memmove/memcopy .etc
	while(true);
}