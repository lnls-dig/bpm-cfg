CFLAGS = -Wall -Werror -O2
PREFIX ?= /usr/local

all: pcie-remove pcie-rescan ioc-restart

install: pcie-remove pcie-rescan ioc-restart
	install $? $(PREFIX)/bin

install-setuid: install
	chmod u+s $(PREFIX)/bin/pcie-rescan $(PREFIX)/bin/pcie-remove $(PREFIX)/bin/ioc-restart

clean:
	rm -f pcie-remove pcie-rescan ioc-restart
