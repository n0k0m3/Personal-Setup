# Setting up Arch
This is setup on EndeavourOS, on barebone Arch should be a little bit different (install `yay` before all of these steps)
## [Setup Swap with hibernation](Swap_Setup.md)
Read this guide BEFORE install EndeavourOS
## Install Nextcloud
```sh
yay -S nextcloud-client
```
## Install [`zsh4humans`](https://github.com/romkatv/zsh4humans)
I don't need anything more fancy than romkatv's `zsh4humans`.
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/n0k0m3/Personal-Setup/main/Setting_up_Arch/setup.sh)"
```
## Setting up `pacman` and `makepkg` config
Set `ParallelDownloads = 10`:
```sh
sudo nano /etc/pacman.conf
```

Set compile flags `CFLAGS="-march=native -mtune=generic ..."` and `MAKEFLAGS="-j12"` for `12` being total number of available cores/threads:
```sh
sudo nano /etc/makepkg.conf
```
## Comparing current installation with installed packages of previous dist
```sh
python3 read_install.py <installed.log file>
```
### Update `installed.log` with current setup
```sh
pacman -Qqet >> installed.log
```
