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

int main(int argc, char** argv) {
    int fd = open("/sys/bus/pci/rescan", O_WRONLY);
    if (fd < 0) {
        perror("Could not open '/sys/bus/pci/rescan'");
        return 1;
    }
    write(fd, "1\n", 2);
    close(fd);
    return 0;
}
