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