CCFLAGS = -ffreestanding -mcmodel=kernel -mno-red-zone -Wall -Wextra -pipe
LDFLAGS = -nostdlib -lgcc -z max-page-size=0x1000

all: release

release: CCFLAGS += -O2 -flto -s
debug:   CCFLAGS += -g
release: kernel.elf
debug:   kernel.elf

OBJECTS = $(patsubst %.S, %.o, $(patsubst %.c, %.o, $(shell find $(SRC) -name '*.S' -o -name '*.c')))

kernel.elf: $(OBJECTS) arch/x86_64/linker.ld
	x86_64-elf-gcc -T $(filter %.ld,$^) $(OBJECTS) -o kernel.elf $(CCFLAGS) $(LDFLAGS)

%.o: %.c
	x86_64-elf-gcc -I . -c $^ -o $@ $(CCFLAGS)

%.o: %.S
	x86_64-elf-gcc -I . -c $^ -o $@ $(CCFLAGS)

.PHONY: clean
clean:
	find -type f -name '*.o' -delete
	find -type f -name '*.elf' -delete