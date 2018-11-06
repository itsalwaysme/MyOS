#include <stdbool.h>
#include <stdint.h>
#include <stddef.h>
#include "include/serial.h"
#include "klibc/include/string.h"

// TODO pretty sure I need some kinds of wait.
// I need printf capability. Maybe make sprintf and just push through here?
// This is x86 specific, the outb and inb need to be a in ageneric cpu thing and this needs to be split or moved there too.

static inline void outb(uint16_t port, uint8_t val)
{
    asm volatile ("outb %0, %1" : : "a"(val), "Nd"(port));
}

static inline uint8_t inb(uint16_t port)
{
    uint8_t ret;
    asm volatile ("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}

void init_serial(void) {
    outb(SERIAL_PORT + 1, 0x00);    // Disable all interrupts
    outb(SERIAL_PORT + 3, 0x80);    // Enable DLAB (set baud rate divisor)
    outb(SERIAL_PORT + 0, 0x03);    // Set divisor to 3 (lo byte) 38400 baud
    outb(SERIAL_PORT + 1, 0x00);    //                  (hi byte)
    outb(SERIAL_PORT + 3, 0x03);    // 8 bits, no parity, one stop bit
    outb(SERIAL_PORT + 2, 0xC7);    // Enable FIFO, clear them, with 14-byte threshold
    outb(SERIAL_PORT + 4, 0x0B);    // IRQs enabled, RTS/DSR set
}

bool is_transmit_empty(void) {
    return (inb(SERIAL_PORT + 5) & 0x20) > 0;
}
 
void write_serial(char* source) {
    size_t length = strlen(source);
    for (size_t i = 0; i < length; i++) {
        while (!is_transmit_empty());
        outb(SERIAL_PORT, source[i]);
    }
}