/* BPM IOCs Utils
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

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

/*
 * Slot allowlists to sanitize user input
 */
static const char* const afc_allowlist[] = {
    "1", "2", "2-1", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"
};

static const char* const rffe_allowlist[] = {
    "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"
};

/*
 * Check if the user provided slot string is valid
 */
static int sanitize_slot(const char* slot, const char* const allowlist[], size_t allowlist_size) {
    for (size_t i = 0; i < allowlist_size; i++) {
        if (strcmp(slot, allowlist[i]) == 0) {
            return 0;
        }
    }
    return -1;
}

int main(int argc, char** argv) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <afc|rffe> <slot_number>\n", argv[0]);
        return 1;
    }

    const char* type = argv[1];
    const char* slot = argv[2];

    const char* const* allowlist;
    size_t allowlist_size;

    /*
     * Checks the IOC type and sets the allowlist
     */
    if (strcmp(type, "afc") == 0) {
        allowlist = afc_allowlist;
        allowlist_size = sizeof(afc_allowlist) / sizeof(afc_allowlist[0]);
    } else if (strcmp(type, "rffe") == 0) {
        allowlist = rffe_allowlist;
        allowlist_size = sizeof(rffe_allowlist) / sizeof(rffe_allowlist[0]);
    } else {
        fprintf(stderr, "Invalid type: %s. Use 'afc' or 'rffe'.\n", type);
        return 2;
    }

    if (sanitize_slot(slot, allowlist, allowlist_size) < 0) {
        fprintf(stderr, "Invalid slot: %s for %s-ioc.\n", slot, type);
        return 3;
    }

    char service[256];
    snprintf(service, sizeof(service), "%s-ioc@%s.service", type, slot);
    if (execl("/usr/bin/systemctl", "systemctl", "restart", service, (char *)NULL) == -1) {
        perror("Failed to execute systemctl");
        return 4;
    }
}
