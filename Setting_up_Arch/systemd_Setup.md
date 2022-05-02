---
layout: default
title: systemd hooks with FIDO2 unlock
parent: Arch Linux Setup
grand_parent: Personal Projects
nav_order: 2
---

# Setting up `systemd` hooks

By default Arch-based distros uses busybox init, which doesn’t support some features comfort from systemd. This guide will help you to setup systemd hooks, switch encryption to LUKS2 for systemd-cryptenroll, use U2F/FIDO2 key to unlock at boot, and Plymouth for boot splash screen.

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
if grep -q "1" <<< "$luksversion"; then
    echo "Converting LUKS1 to LUKS2"
    cryptsetup convert --type luks2 $lukspart
elif grep -q "2" <<< "$luksversion"; then
    echo "Partition is LUKS2 already"
else
    echo "Unknown LUKS version"
    exit 1
fi
```

(Optional) Add new secure passphrase if needed.

```sh
sudo su -
lukspart=($(sudo blkid | grep crypto_LUKS))
lukspart=($(sed -r "s/(.*):/\1/" <<< ${lukspart[0]}))
cryptsetup luksAddKey $lukspart # enter existing passphrase then new passphrase with confirmation
cryptsetup luksKillSlot $lukspart 0 # remove old passphrase, enter new passphrase
```

Setup U2F/FIDO2 key unlock.

```sh
# :: Install libfido2 :: #
yay -S --noconfirm --needed libfido2
# :: Configure luks2 decryption with FIDO2 using systemd-cryptenroll :: #
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/n0k0m3/Personal-Setup/main/Setting_up_Arch/fido2_luks_setup.sh)"
```

This will use `hmac-secret` extension of FIDO2 protocol. This method is compatible with almost all FIDO2 devices (I'm using Yubico Security Key (Blue Key) as I can just use a single U2F key to unlock all OpenPGP, smart card, and OTP keys instead of storing them).

## Script Source code

<div class="code-example" markdown="1">

[Download systemd_setup.sh](systemd_setup.sh){: .btn }

</div>
{% capture systemd_setup %}
{% highlight shell linenos %}
#!/usr/bin/env bash

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Must run as root"
    exit
fi

# -x = show every command executed
# -e = abort on failure
set -xe

module_hooks() {
    # :: set modules nvidia or intel (i915) :: #
    local module_nvidia=$(lsmod | grep nvidia)
    local module_intel=$(lsmod | grep i915)
    # :: if lsmod not empty :: #
    if ! [ -z "$module_nvidia" ]
    then
        echo "nvidia nvidia_modeset nvidia_uvm nvidia_drm"
    elif ! [ -z "$module_intel" ]
    then
        echo "i915"
    else
        echo "Non NVIDIA/Intel module detected, exiting"
        exit 1
    fi
}

hooks() {
    # :: Switch to systemd hooks :: #
    sed -ri "s/^(HOOKS=\"base).*(autodetect.+keyboard).+(encrypt) (.+)/\1 systemd \2 sd-vconsole sd-encrypt \4/" /etc/mkinitcpio.conf

    # :: Kernel parameters for systemd hooks :: #
    local luksuuid=($(blkid | grep crypto_LUKS))
    local luksuuid=($(sed -r "s/UUID=\"(.*)\"/\1/" <<< ${luksuuid[1]}))
    # luksdevice=($(echo luks-$luksuuid))
    # lukspart=($(echo /dev/mapper/$luksdevice))
    sed -ri "s/cryptdevice.+ (root)/rd.luks.uuid=$luksuuid \1/" /etc/default/grub
}

plymouth() {
    # :: plymouth hooks :: #
    sed -ri "s/^(HOOKS=\"base systemd)/\1 sd-plymouth/" /etc/mkinitcpio.conf
    local modules=$(module_hooks)
    sed -ri "s/^(MODULES=\")/\1$modules /" /etc/mkinitcpio.conf

    # :: plymouth kernel parameters :: #
    sed -ri "s/^(GRUB_CMDLINE_LINUX_DEFAULT.+)\"/\1 quiet splash vt.global_cursor_default=0 fbcon=nodefer\"/" /etc/default/grub

    # :: plymouth config :: #
    sed -ri "s/^(Theme=).+/\1colorful_loop/" /etc/plymouth/plymouthd.conf
    sed -ri "s/^(ShowDelay=).+/\10/" /etc/plymouth/plymouthd.conf

    # :: plymouth smooth transition :: #
    local displaymanager=($(systemctl status display-manager))
    local plymouthdm=($(sed -r "s/(.*)(\.service)/\1-plymouth\2/" <<< ${displaymanager[1]}))
    systemctl disable ${displaymanager[1]}
    systemctl enable $plymouthdm
}

post_install() {
    # :: Remake images and grub :: #
    grub-mkconfig -o /boot/grub/grub.cfg
    mkinitcpio -P
}

hooks "$@"
plymouth "$@"
post_install "$@"
{% endhighlight %}
{% endcapture %}
{% include fix_linenos.html code=systemd_setup %}


<div class="code-example" markdown="1">

[Download fido2_luks_setup.sh](fido2_luks_setup.sh){: .btn }

</div>
{% capture fido2_luks_setup %}
{% highlight shell linenos %}
#!/usr/bin/env bash

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Must run as root"
    exit
fi

# -x = show every command executed
# -e = abort on failure
set -xe

fido2() {
    # :: FIDO2 systemd-cryptenroll :: #
    local lukspart=($(sudo blkid | grep crypto_LUKS))
    local lukspart=($(sed -r "s/(.*):/\1/" <<< ${lukspart[0]}))
    systemd-cryptenroll --fido2-device=auto $lukspart

    # :: FIDO2 decryption kernel parameters :: #
    local luksuuid=($(blkid | grep crypto_LUKS))
    local luksuuid=($(sed -r "s/UUID=\"(.*)\"/\1/" <<< ${luksuuid[1]}))

    # setup FIDO2 device to unlock luks2 partition, timeout is set to 10 seconds and then secure passphrase is asked
    sed -ri "s/^(luks-.*)/#\1/" /etc/crypttab
    echo "luks-$luksuuid UUID=$luksuuid - fido2-device=auto,token-timeout=10" >> /etc/crypttab
    ln /etc/crypttab /etc/crypttab.initramfs # add crypttab to initramfs
}

post_install() {
    # :: Remake images and grub :: #
    grub-mkconfig -o /boot/grub/grub.cfg
    mkinitcpio -P
}

fido2 "$@"
post_install "$@"
{% endhighlight %}
{% endcapture %}
{% include fix_linenos.html code=fido2_luks_setup %}
