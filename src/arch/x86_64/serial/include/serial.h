#ifndef _SERIAL_H_
#define _SERIAL_H_

#define SERIAL_PORT 0x3F8   /* COM1 */

void init_serial(void);
void write_serial(char*);

#endif // SERIAL_H_