CFLAGS = -Wall -Werror -O2

all: pcie-remove

pcie-remove: pcie-remove.c
	cc $(CFLAGS) $< -o $@

clean:
	rm -f pcie-remove
