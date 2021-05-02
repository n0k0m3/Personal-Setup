# Personal setup stash

This repo contains all of my personal codes and guides for personal setups. No personal info is here and most scripts work with all common consumer-based distros (Debian/Ubuntu, Arch, maybe RHEL-based, Fedora for some)

## `fstab` mount with user permssion

Use KDE/GNOME partition manager to manage mount point and use mount options: `uid=1000,gid=1001,umask=022`  
Or append to `/etc/fstab`:
```
UUID=<disk_UUID>   <mount_point>    <format>    uid=1000,gid=1001,umask=022,noatime 0 1 
```

## Install ZSH
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/n0k0m3/Personal-Setup/main/install_zsh.sh)"
```

## [Tensorflow GPU Docker](Tensorflow_Docker.md)

## [VM and Single GPU Passthrough Guide](GPU_Passthrough/Single_GPU_Passthrough_Guide.md)
