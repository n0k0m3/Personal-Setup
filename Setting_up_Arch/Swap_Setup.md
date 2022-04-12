# Setting up Swap with hibernation

## Arch setup

Setting up Arch with this partition Setup with NO SWAP:

| Partition            | Mount Point | Filesystem | Size          | Encryption Status |
| -------------------- | ----------- | ---------- | ------------- | ----------------- |
| EFI system partition | `/boot/efi` | FAT32      | 300-550 MB    | Unencrypted       |
| `/boot` partition    | `/boot/efi` | ext4       | 200-500 MB    | Unencrypted       |
| `root` partition     | `/`         | btrfs      | Rest of space | Encrypted         |

Note: mount EFI with boot flag

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
