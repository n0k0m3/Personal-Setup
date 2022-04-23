# Post-Installation Setup
[[Return to previous page]](README.md)
## Install Nextcloud
```sh
yay -S nextcloud-client
```
Sync `.dotfiles` with Nextcloud + `flameshot` shortcut
## Install [`zsh4humans`](https://github.com/romkatv/zsh4humans)
I don't need anything more fancy than romkatv's `zsh4humans`
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/n0k0m3/Personal-Setup/main/Setting_up_Arch/setup.sh)"
```
## Setting up `pacman` and `makepkg` config
Set `ParallelDownloads = 10`:
```sh
sudo nano /etc/pacman.conf
```

Set compile flags `CFLAGS="-march=native -mtune=native ..."` and `MAKEFLAGS="-j12"` for `12` being total number of available cores/threads:
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