CFLAGS = -Wall -Werror -O2
PREFIX ?= /usr/local

all: pcie-remove pcie-rescan

pcie-remove: pcie-remove.c
	cc $(CFLAGS) $< -o $@

pcie-rescan: pcie-rescan.c
	cc $(CFLAGS) $< -o $@

install: pcie-remove pcie-rescan
	cp $? $(PREFIX)/bin

clean:
	rm -f pcie-remove pcie-rescan
