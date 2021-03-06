#ifndef _BOOT_MMU_H_
#define _BOOT_MMU_H_

#define PML4_SIZE       0x1000
#define PML4_ALIGNMENT  0x1000
#define PML4_ENTRY_SIZE 8
#define PML4_ADDR_TO_ENTRY_INDEX(addr) (((addr) >> 39) & 0x1FF)

#define PDPT_SIZE       0x1000
#define PDPT_ALIGNMENT  0x1000
#define PDPT_ENTRY_SIZE 8
#define PDPT_ADDR_TO_ENTRY_INDEX(addr) (((addr) >> 30) & 0x1FF)

#define PAGE_DIRECTORY_SIZE      0x1000
#define PAGE_DIRECTORY_ALIGNMENT 0x1000
#define PAGE_DIRECTORY_ENTRY_SIZE 8

#define PAGE_TABLE_SIZE       0x1000
#define PAGE_TABLE_ALIGNMENT  0x1000
#define PAGE_TABLE_ENTRY_SIZE 8

#define MMU_PRESENT     (1 << 0)
#define MMU_WRITABLE    (1 << 1)
#define MMU_USER_MEMORY (1 << 2)
#define MMU_PDE_TWO_MB  (1 << 7)

#endif // _BOOT_MMU_H_