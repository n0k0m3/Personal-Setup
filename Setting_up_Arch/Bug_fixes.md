---
layout: default
title: Bugs Fixes
parent: Arch Linux Setup
grand_parent: Personal Projects
nav_order: 4
---

# Bugs Fixes

## OBS Studio flickering with Intel Graphics

With some Intel graphics cards on XOrg (in my case, Tiger Lake Xe), OBS Studio will flicker with screen capture.

<div class="code-example" markdown="1">

```sh
sudo nano /etc/X11/xorg.conf.d/20-intel.conf
```

</div>
{% capture fix_intel %}
{% highlight shell linenos %}
Section "Device"
    Identifier "Intel Graphics"
    Driver "modesetting"
EndSection
{% endhighlight %}
{% endcapture %}
{% include fix_linenos.html code=fix_intel %}

Reboot or restart XOrg server to apply the fix.

## Delete Goodix Fingerprint Sensor saved fingerprint data

If you installed Windows and enrolled fingerprints with Goodix Fingerprint Sensor, the saved fingerprint data will prevent new enrollments in Linux.

**Requirements:** 
- `libfprint`, `fprintd` for fingerprint sensor
- `python3` to run the script

Download the following script and run it (adapted from [this issue](https://gitlab.freedesktop.org/libfprint/libfprint/-/issues/415#note_1063158) but use the new `clear_storage_sync()` method instead of `delete_print_sync()` loop):

[Download delete_goodix_fingerprint_data.py](delete_goodix_fingerprint_data.py){: .btn }

```sh
sudo python3 delete_goodix_fingerprint_data.py
```

**Other Solution** 

Another solution is provided by `Devyn_Cairns` from Framework Community [(Link to the solution)](https://community.frame.work/t/fingerprint-scanner-compatibility-with-linux-ubuntu-fedora-etc/1501/214). The author provided an AppImage to run the script with all dependencies. From my testing it's more stable than my script.

```sh
sudo ./fprint-clear-storage-0.0.1-x86_64.AppImage
```

## Script Source code

<div class="code-example" markdown="1">

[Download delete_goodix_fingerprint_data.py](delete_goodix_fingerprint_data.py){: .btn }

</div>
{% capture fix_fprintd %}
{% highlight python linenos %}
#! /usr/bin/python3

import gi
gi.require_version('FPrint', '2.0')
from gi.repository import FPrint

ctx = FPrint.Context()

for dev in ctx.get_devices():
    print(dev)
    print(dev.get_driver())
    print(dev.props.device_id);

    dev.open_sync()
    dev.clear_storage_sync()
    dev.close_sync()
{% endhighlight %}
{% endcapture %}
{% include fix_linenos.html code=fix_fprintd %}
