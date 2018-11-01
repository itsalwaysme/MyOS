#include <stdbool.h>
#include <stddef.h>

// TODO benchark O2 vs O3

// __used__ stops this function being removed. It must be present.
// no-tree-loop-distribute-patterns required to stop this optimizing to itself. See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=56888
__attribute__((__used__))
__attribute__((optimize("O3,-fno-tree-loop-distribute-patterns")))
void* memset(void* bufptr, int value, size_t size) {
	unsigned char* buf = (unsigned char*) bufptr;
	for (size_t i = 0; i < size; i++) {
		buf[i] = (unsigned char) value;
  }
	return bufptr;
}

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