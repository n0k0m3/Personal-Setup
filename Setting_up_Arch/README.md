# Setting up Arch
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
pacman -Qqet >> installed.txt
```
