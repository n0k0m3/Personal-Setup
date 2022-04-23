# Setting up Arch

[[Return to home]](../index.md)

## Arch setup

Setting up Arch with this partition Setup with NO SWAP:

| Partition            | Mount Point | Filesystem | Size          | Encryption Status |
| -------------------- | ----------- | ---------- | ------------- | ----------------- |
| EFI system partition | `/boot/efi` | FAT32      | 300-550 MB    | Unencrypted       |
| `/boot` partition    | `/boot/efi` | ext4       | 200-500 MB    | Unencrypted       |
| `root` partition     | `/`         | btrfs/LUKS | Rest of space | Encrypted         |

Note: mount EFI with `boot` flag and `/` with `root` flag.

## [Setup Swap with hibernation after installation](Swap_Setup.md)

This is setup on EndeavourOS/Manjaro, on barebone Arch should be a little bit different (install `yay` before all of these steps)

## Hide `GRUB` at boot

```sh
$ sudo nano /etc/default/grub
GRUB_DEFAULT=0
GRUB_TIMEOUT=1
GRUB_TIMEOUT_STYLE=hidden
```
Hold `Shift` or spam `ESC`/`F4` during boot to bring up `GRUB` menu.

## [Setting up `systemd` hooks and other setups](systemd_Setup.md)

By default Arch-based distros uses `busybox` init, which doesn't support some features comfort from `systemd`. This guide will help you to setup `systemd` hooks, switch encryption to LUKS2 for `systemd-cryptenroll`, use U2F/FIDO2 key to unlock at boot, and `Plymouth` for boot splash screen.

## [Post-Installation](post_install.md)
