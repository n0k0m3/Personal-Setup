# Setting up Arch
## Install [`zsh4humans`](https://github.com/romkatv/zsh4humans)
I don't need anything more fancy than romkatv's `zsh4humans`.
```sh
if command -v curl >/dev/null 2>&1; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
else
  sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
fi
```
## Setting up pacman and makepkg config
Set `ParallelDownloads = 10`:
```sh
sudo nano /etc/pacman.conf
```

Set compile flags `CFLAGS="-march=native -mtune=generic ..."` and `MAKEFLAGS="-j12"` for 12 being total number of available cores/threads:
```sh
sudo nano /etc/makepkg.conf
```
## Comparing current installation with installed packages of previous dist
```sh
python3 read_install.py
```
### Update `installed.txt` with current setup
```sh
pacman -Qqet >> installed.log
```
