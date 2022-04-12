#!/bin/bash
# List all explicitly installed packages
pacman -Qqe
# List all foreign packages
pacman -Qqm
# List all native packages
pacman -Qqn
# List all explicitly installed native packages
pacman -Qqent
# List all explicitly installed packages that are not required by any other package (Recommended for backups)
pacman -Qqet
