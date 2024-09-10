CFLAGS = -Wall -Werror -O2
PREFIX ?= /usr/local

all: pcie-remove pcie-rescan

install: pcie-remove pcie-rescan
	install $? $(PREFIX)/bin

clean:
	rm -f pcie-remove pcie-rescan
