---
layout: default
title: Arch Linux Setup
parent: Personal Projects
has_children: true
nav_order: 1
---

# Setting up Arch

## Arch setup

Setting up Arch with this partition Setup with NO SWAP:

| Partition            | Mount Point | Filesystem | Size          | Encryption Status |
| -------------------- | ----------- | ---------- | ------------- | ----------------- |
| EFI system partition | `/boot/efi` | FAT32      | 300-550 MB    | Unencrypted       |
| `/boot` partition    | `/boot/efi` | ext4       | 200-500 MB    | Unencrypted       |
| `root` partition     | `/`         | btrfs/LUKS | Rest of space | Encrypted         |

Note: mount EFI with `boot` flag and `/` with `root` flag.

## Hide `GRUB` at boot

```sh
$ sudo nano /etc/default/grub
GRUB_DEFAULT=0
GRUB_TIMEOUT=1
GRUB_TIMEOUT_STYLE=hidden
```