#include <stdio.h>
#include <stdlib.h>

int main(void) {
    FILE *f = fopen("/proc/sys/vm/drop_caches", "w");

    if (f == NULL) {
        fprintf(stderr, "could not open /proc/sys/vm/drop_caches\n");
        return EXIT_FAILURE;
    }

    int const bytes_written = fprintf(f, "3\n");
    if (bytes_written != 2) {
        fprintf(stderr, "could not write 3 to /proc/sys/vm/drop_caches\n");
    }

    fclose(f);
    return EXIT_SUCCESS;
}
