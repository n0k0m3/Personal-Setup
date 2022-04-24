---
layout: default
title: Swap with hibernation
parent: Arch Linux Setup
grand_parent: Personal Projects
nav_order: 1
---

# Setting up Swap with hibernation

This is setup on EndeavourOS/Manjaro, on barebone Arch should be a little bit different (install yay before all of these steps)

## Add swap after installation

Requires `gcc`, `wget` to be installed (default on EndeavourOS)

Run:

```sh
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/n0k0m3/Personal-Setup/main/Setting_up_Arch/swap_setup.sh)"
```

Sources:

- https://discovery.endeavouros.com/btrfs/btrfs-resume-and-hibernate-setup/2021/12/
- https://discovery.endeavouros.com/encrypted-installation/btrfsonluks-quick-copy-paste-version/2021/03/
- https://discovery.endeavouros.com/storage-and-partitions/adding-swap-after-installation/2021/03/
