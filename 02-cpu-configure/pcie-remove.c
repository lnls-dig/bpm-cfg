/* BPM PCIe Utils
 * Copyright (C) 2024 CNPEM
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>

/*
 * Slot whitelist to sanitize user input
 */
const char* const slot_whitelist[] = {
    "1",
    "2",
    "2-1",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
};

/*
 * Check if the user provided slot string is valid
 */
int sanitize_slot(const char* slot) {
    const size_t items = sizeof(slot_whitelist) / sizeof(*slot_whitelist);
    int ret = -1;

    for (size_t i = 0; i < items; i++) {
        if (strcmp(slot, slot_whitelist[i]) == 0) {
            ret = 0;
        }
    }

    return ret;
}

int main(int argc, char** argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s slot_num\n", argv[0]);
        return 1;
    }

    const char* slot = argv[1];

    if (sanitize_slot(slot) < 0) {
        fprintf(stderr, "Slot %s invalid!\n", slot);
        return 2;
    }

    char slot_addr_path[256];
    snprintf(slot_addr_path, sizeof(slot_addr_path), "/sys/bus/pci/slots/%s/address", slot);
    int fd_addr = open(slot_addr_path, O_RDONLY);
    if (fd_addr < 0) {
        fprintf(stderr, "Slot %s not found!\n", argv[1]);
        return 3;
    }

    char slot_addr[64];
    ssize_t bytes = read(fd_addr, slot_addr, sizeof(slot_addr));
    if (bytes < 0) {
        fprintf(stderr, "Error reading from '%s': %s!\n", slot_addr_path, strerror(errno));
        return 4;
    } else if (bytes == 0) {
        fprintf(stderr, "Reading from '%s' returns an empty string!\n", slot_addr_path);
        return 5;
    }
    close(fd_addr);

    /*
     * Remove linefeed character
     */
    slot_addr[bytes - 1] = 0;
    printf("Slot %s is %s\n", argv[1], slot_addr);

    char slot_remove_path[256];
    snprintf(slot_remove_path, sizeof(slot_remove_path), "/sys/bus/pci/devices/%s.0/remove", slot_addr);

    int fd = open(slot_remove_path, O_WRONLY);
    if (fd < 0) {
        fprintf(stderr, "Could not open '%s': %s\n", slot_remove_path, strerror(errno));
        return 6;
    }
    bytes = write(fd, "1\n", 2);
    if (bytes == 2) {
        printf("Slot %s removed successfuly.\n", slot);
    } else if (bytes < 0) {
        fprintf(stderr, "Could not write to '%s': %s\n", slot_remove_path, strerror(errno));
        close(fd);
        return 7;
    }
    close(fd);
    return 0;
}
