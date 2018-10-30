#ifndef _CPU_MSR_H_
#define _CPU_MSR_H_

#define CR0_PROTECTED_MODE_ENABLED      (1 << 0)
#define CR0_EXTENSION_TYPE              (1 << 4)
#define CR0_PAGE                        (1 << 31)
#define CR0_NE                          (1 << 5)
#define CR0_MP                          (1 << 1)

#define XCR0_X87                        (1 << 0)
#define XCR0_SSE                        (1 << 1)
#define XCR0_AVX                        (1 << 2)
#define XCR0_OPMASK                     (1 << 5)
#define XCR0_ZMM_Hi256                  (1 << 6)
#define XCR0_Hi16_ZMM                   (1 << 7)

#define CR4_PAGE_SIZE_EXTENSION         (1 << 4)
#define CR4_PHYSICAL_ADDRESS_EXTENSION  (1 << 5)
#define CR4_PAGE_GLOBAL_ENABLED         (1 << 7)
#define CR4_PERFORMANCE_COUNTER_ENABLED (1 << 8)
#define CR4_OSFXSR                      (1 << 9)
#define CR4_OSXMMEXCPT                  (1 << 10)
#define CR4_OSXSAVE                     (1 << 18)

#define MSR_EFER     0xC0000080
#define MSR_EFER_LME (1 << 8)

#endif // _CPU_MSR_H_