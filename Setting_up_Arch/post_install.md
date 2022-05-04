---
layout: default
title: Post-Installation Setup
parent: Arch Linux Setup
grand_parent: Personal Projects
nav_order: 3
---

# Post-Installation Setup

## Install [`zsh4humans`](https://github.com/romkatv/zsh4humans)

I don't need anything more fancy than romkatv's `zsh4humans`

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/n0k0m3/Personal-Setup/main/Setting_up_Arch/setup.sh)"
```

## Install Nextcloud

```sh
sudo pacman -S nextcloud-client
```

Sync `.dotfiles` with Nextcloud + `flameshot` shortcut

## Setting up `pacman` and `makepkg` config

```sh
sudo nano /etc/pacman.conf
```

Set `ParallelDownloads = 10`:

```sh
sudo nano /etc/makepkg.conf
```

Set compile flags `CFLAGS="-march=native -mtune=native ..."` and `MAKEFLAGS="-j12"` for `12` being total number of available cores/threads:

## Comparing current installation with installed packages of previous dist

[Download read_install.py](read_install.py){: .btn }

```sh
python3 read_install.py <installed.log file>
```

### Update `installed.log` with current setup

```sh
pacman -Qqet >> installed.log
```

## Script Source code

<div class="code-example" markdown="1">

[Download setup.sh](setup.sh){: .btn }

</div>
{% capture zsh_setup %}
{% highlight shell linenos %}
#!/bin/sh
echo "################################################################"
echo "Cloning Personal Setup repo"
git clone https://github.com/n0k0m3/Personal-Setup --depth=1
cd Personal-Setup/Setting_up_Arch


# Install ZSH
get_distribution() {
	lsb_dist=""
	# Every system that we officially support has /etc/os-release
	if [ -r /etc/os-release ]; then
		lsb_dist="$(. /etc/os-release && echo "$ID")"
	fi
	# Returning an empty string here should be alright since the
	# case statements don't act unless you provide an actual value
	echo "$lsb_dist"
}

lsb_dist=$( get_distribution )
lsb_dist="$(echo "$lsb_dist" | tr '[:upper:]' '[:lower:]')"

case "$lsb_dist" in

    ubuntu|debian|raspbian)
        sudo apt-get update && sudo apt-get install zsh curl -y
    ;;

    endeavouros|arch)
        sudo pacman -S zsh curl
    ;;

	centos|fedora|rhel)
		sudo yum install -y -q zsh
	;;

esac

# Automatic copy config
echo "################################################################"
echo "Copy .dotfiles configs"
cp -r -a .dotfiles/. ~

# Initiate ZSH
zsh
{% endhighlight %}
{% endcapture %}
{% include fix_linenos.html code=zsh_setup %}

<div class="code-example" markdown="1">

[Download read_install.py](read_install.py){: .btn }

</div>
{% capture installquery %}
{% highlight python linenos %}
import subprocess
import sys
will_install = []
with open(sys.argv[1],"r") as f:
    reader = f.read()
    reader = reader.split("\n")[:-1]
    for r in reader:
        will_install.append(r)

o = subprocess.run(["pacman","-Qq"],capture_output=True)
installed = o.stdout.decode().split("\n")
for s in will_install:
    if s not in installed and "perl" not in s:
        print(s)
{% endhighlight %}
{% endcapture %}
{% include fix_linenos.html code=installquery %}
