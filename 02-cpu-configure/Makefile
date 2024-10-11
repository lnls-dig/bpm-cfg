CFLAGS = -Wall -Werror -O2
PREFIX ?= /usr/local

all: pcie-remove pcie-rescan ioc-restart

install: pcie-remove pcie-rescan ioc-restart
	install $? $(PREFIX)/bin

clean:
	rm -f pcie-remove pcie-rescan ioc-restart
