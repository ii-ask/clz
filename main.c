#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

extern int clz(uint64_t);

int main(int argc, char **argv) {
  if (argc != 2)
    return EXIT_FAILURE;
  uint64_t n = strtoul(argv[1], NULL, 16);
  if (errno)
    return EXIT_FAILURE;
  printf("%d\n", clz(n));
  return EXIT_SUCCESS;
}
