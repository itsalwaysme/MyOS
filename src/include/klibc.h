#include <stddef.h>

#ifndef _KLIBC_H_
#define _KLIBC_H_

__attribute__((__noreturn__))
void abort(void);

int memcmp(const void*, const void*, size_t);
void* memcpy(void* __restrict, const void* __restrict, size_t);
void* memmove(void*, const void*, size_t);
void* memset(void*, int, size_t);

#endif // _KLIBC_H_