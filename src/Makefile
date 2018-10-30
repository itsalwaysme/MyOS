# TODO make doesn't detect changes to files

SRC = .
BUILD = ../build

# TODO check if O2 actually emits any SSE2 or anything.
# TODO do a dist build?
CCFLAGS = -s -flto -ffreestanding -mcmodel=kernel -mno-red-zone -O2 -Wall -Wextra -pipe
LDFLAGS = -nostdlib -lgcc -z max-page-size=0x1000

OBJECTS = $(patsubst %.S, %.o, $(patsubst %.c, %.o, $(shell find $(SRC) -name '*.S' -o -name '*.c')))

all: $(BUILD)/kernel.elf

$(BUILD)/kernel.elf: $(OBJECTS) $(realpath $(SRC))/linker.ld
	cd $(BUILD) && x86_64-myos-elf-gcc -T $(filter %.ld,$^) $(OBJECTS) -o kernel.elf $(CCFLAGS) $(LDFLAGS)

%.o: %.c
	x86_64-myos-elf-gcc -I . -c $^ -o $(BUILD)/$@ $(CCFLAGS)

%.o: %.S
	x86_64-myos-elf-gcc -I . -c $^ -o $(BUILD)/$@ $(CCFLAGS)

clean:
	find $(BUILD) -type f -name '*.o' -delete
	find $(BUILD) -type f -name '*.elf' -delete