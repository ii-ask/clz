CC = gcc -g -no-pie
CFLAGS = -Og -Wall
LDFLAGS = 
ASFLAGS = -g

# Configurable parameters
PROCEDURE ?= clz.s:clz
ILIMIT ?= 48
MAXSIZE ?= 192
BADINSNS ?= '*cnt,call*'
MINIPC ?= 1.87

MAXINSNS = $(ILIMIT)

CHECK = ./check-solution $(OPTS) --procedure $(PROCEDURE) \
	                 --max-size $(MAXSIZE) --bad-insns $(BADINSNS) $(EXTRA)
RUN = ./run-solution $(OPTS) --procedure $(PROCEDURE) \
                     --max-insns $(MAXINSNS) $(EXTRA) -- ./main
INSTALL = sudo apt-get install -q=2 --no-install-recommends

.packages:
	 $(INSTALL) valgrind llvm-8
	 touch $@

check: .packages main
	$(CHECK)

main: main.o clz.o
	$(CC) $(LDFLAGS) -o $@ $^

test-1: check
	$(RUN) 0xFFFFFFFFFFFFFFFF

test-2: check
	$(RUN) 0x0

test-3: check
	$(RUN) 0x10000

test-4: check
	$(RUN) 0x001F089ADF39FE00

test-random: MAXINSNS=$(shell echo $$(($(ILIMIT)*1000))) 
test-random: check
	$(RUN) -r 1000

test-all: test-1 test-2 test-3 test-4 test-random

test-bonus: CHECK += --min-ipc $(MINIPC)
test-bonus: check

clean:
	rm -f .packages main *.o *.out *~

.PHONY: check clean test-1 test-2 test-3 test-4 test-random test-all

# vim: ts=8 sw=8 noet
