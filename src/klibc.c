#include <stdbool.h>
#include <stddef.h>

// NOTES:
// __used__ stops these function being removed. They must be present as GCC may convert general code into calls to these.
// no-tree-loop-distribute-patterns required to stop these functions optimizing to themselves. See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=56888

__attribute__((__used__))
__attribute__((optimize("O3,-fno-tree-loop-distribute-patterns")))
void* memmove(void* dstptr, const void* srcptr, size_t size) {
	unsigned char* dst = (unsigned char*) dstptr;
	const unsigned char* src = (const unsigned char*) srcptr;
	if (dst < src) {
		for (size_t i = 0; i < size; i++)
			dst[i] = src[i];
	} else {
		for (size_t i = size; i != 0; i--)
			dst[i-1] = src[i-1];
	}
	return dstptr;
}

__attribute__((__used__))
__attribute__((optimize("O3,-fno-tree-loop-distribute-patterns")))
void* memset(void* bufptr, int value, size_t size) {
	unsigned char* buf = (unsigned char*) bufptr;
	for (size_t i = 0; i < size; i++) {
		buf[i] = (unsigned char) value;
    }
	return bufptr;
}

__attribute__((__used__))
__attribute__((optimize("O3,-fno-tree-loop-distribute-patterns")))
int memcmp(const void* aptr, const void* bptr, size_t size) {
	const unsigned char* a = (const unsigned char*) aptr;
	const unsigned char* b = (const unsigned char*) bptr;
	for (size_t i = 0; i < size; i++) {
		if (a[i] < b[i])
			return -1;
		else if (b[i] < a[i])
			return 1;
	}
	return 0;
}

__attribute__((__used__))
__attribute__((optimize("O3,-fno-tree-loop-distribute-patterns")))
void* memcpy(void* restrict dstptr, const void* restrict srcptr, size_t size) {
	unsigned char* dst = (unsigned char*) dstptr;
	const unsigned char* src = (const unsigned char*) srcptr;
	for (size_t i = 0; i < size; i++)
		dst[i] = src[i];
	return dstptr;
}

__attribute__((__used__))
__attribute__((__noreturn__))
void abort(void) {
    // TODO proper kernel panic message here
	while (true);
	__builtin_unreachable();
}