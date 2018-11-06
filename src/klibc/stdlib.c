#include <stdbool.h>

// NOTES:
// __used__ stops these function being removed. They must be present as GCC may convert general code into calls to these.
// no-tree-loop-distribute-patterns required to stop these functions optimizing to themselves. See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=56888

__attribute__((__used__))
__attribute__((__noreturn__))
void abort(void) {
    // TODO proper kernel panic message here
    while (true);
    __builtin_unreachable();
}