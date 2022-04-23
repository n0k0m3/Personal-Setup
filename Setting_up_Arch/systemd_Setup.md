# Setting up `systemd` hooks

## `systemd` hooks and Plymouth boot splash screen

Follwing script will change `busybox` init to `systemd` hooks and setup `plymouth` with `colorful_loop` theme.

Requirements: `yay` (default on EndeavourOS)

```sh
# :: Install plymouth :: #
yay -S --noconfirm --needed plymouth-git plymouth-theme-colorful-loop-git
# :: systemd setup script :: #
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/n0k0m3/Personal-Setup/main/Setting_up_Arch/systemd_setup.sh)"
```

## LUKS2 encryption with U2F/FIDO2 key unlock

Requires `systemd` hooks with `sd-encrypt`.

Boot from USB/ISO of Arch/EndeavourOS. We don't need `chroot`. Following script will convert LUKS1 to LUKS2.
```sh
# :: Convert LUKS1 to LUKS2 :: #
sudo su -
lukspart=($(sudo blkid | grep crypto_LUKS))
lukspart=($(sed -r "s/(.*):/\1/" <<< ${lukspart[0]}))
luksversion=$(sudo cryptsetup luksDump $lukspart | grep Version)
luksversion=($(echo ${luksversion[-1]}))
if [[ $luksversion == 1 ]]; then
    echo "Converting LUKS1 to LUKS2"
    cryptsetup convert --type luks2 $lukspart
else
    echo "Partition is LUKS2 already"
fi
```

Reboot to system. Enroll a new secure passphrase if needed.
```sh
sudo su -
lukspart=($(sudo blkid | grep crypto_LUKS))
lukspart=($(sed -r "s/(.*):/\1/" <<< ${lukspart[0]}))
cryptsetup luksAddKey $lukspart # enter existing passphrase then new passphrase with confirmation
cryptsetup luksKillSlot $lukspart 0 # remove old passphrase, enter new passphrase
```

Setup U2F/FIDO2 key unlock. This will use `hmac-secret` extension of FIDO2 protocol. This method is compatible with almost all FIDO2 devices (I'm using Yubico Security Key (Blue Key) as I can just use 1 U2F key to unlock all OpenPGP, smart card, and OTP keys instead of storing them ).

```sh
# :: Install libfido2 :: #
yay -S --noconfirm --needed libfido2
# :: Configure luks2 decryption with FIDO2 using systemd-cryptenroll :: #
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/n0k0m3/Personal-Setup/main/Setting_up_Arch/fido2_luks_setup.sh)"
```