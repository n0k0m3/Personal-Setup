# Running Tensorflow with GPU support (NVIDIA) in docker

Following guide was tested on EndeavourOS (Arch-based) Linux distro.

## Why?

Installing dependencies and setting up notebooks is usually a PITA: installing CUDA with CuDNN and TensorRT doesn't have a common and easy to follow guide, along with recent (not recent) release of python 3.9, most ML/DL packages are not updated to this wheel. Also setting up `venv` is hard to maintain and migrate as you have to backup the whole environment to other machine.

`tensorflow/tensorflow` docker container solves this problem by allowing user to backup personalized config, while don't have to deal with maintaining the environment. Another perks is you can choose

## Requirements

Nvidia driver is installed (using `nvidia-installer-dkms` from EndeavourOS or from Arch repo, other distro DIY). Note: `nouveau` (default open-source NVIDIA driver) is not supported

## Install docker

**Arch**: [(Arch Wiki guide)](https://wiki.archlinux.org/index.php/docker#Run_GPU_accelerated_Docker_containers_with_NVIDIA_GPUs)

Install `docker`
```sh
sudo pacman -S docker
```

## Problem with Docker and BTRFS (copied from [here](https://github.com/egara/arch-btrfs-installation/blob/master/README.md)) ##
More than a problem is a caveat. If the main filesystem for root is BTRFS, docker will use BTRFS storage driver (Docker selects the storage driver automatically depending on the system's configuration when it is installed) to create and manage all the docker images, layers and volumes. It is ok, but there is a problem with snapshots. Because **/var/lib/docker** is created to store all this stuff in a BTRFS subvolume which is into root subvolume, all this data won't be included within the snapshots. In order to allow all this data be part of the snapshots, we can change the storage driver used by Docker. The preferred one is **overlay2** right now. Please, check out [this reference](https://docs.docker.com/engine/userguide/storagedriver/selectadriver/) in order to select the proper storage driver for you. You must know that depending on the filesystem you have for root, some of the storage drivers will not be allowed.

For using overlay2:

- Create a file called **storage-driver.conf** within **/etc/systemd/system/docker.service.d/**. If the directory doens't exist, create the directory first.

```sh
sudo mkdir -p /etc/systemd/system/docker.service.d/
sudo nano /etc/systemd/system/docker.service.d/storage-driver.conf
```

- This is the content of **storage-driver.conf**

```sh
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// --storage-driver=overlay2
```

- Create **/var/lib/docker/** and disable CoW (copy on write for BTRFS):

```sh
sudo chattr +C /var/lib/docker
```

- Enable and start the service

```sh
sudo systemctl enable --now dockerd
```
(OPTIONAL, WARNING: insecure) Add your user to docker group in order to use docker command without `sudo`
```sh
sudo groupadd docker
sudo usermod -aG docker $USER
```
## Install nvidia-container toolkit for GPU access
Install `nvidia-container-toolkit`(AUR)
```sh
yay nvidia-container-toolkit
```

Add this kernel parameter to `/etc/default/grub`
```sh
GRUB_CMDLINE_LINUX_DEFAULT="... systemd.unified_cgroup_hierarchy=false"
```
Regenerate `grub`
```sh
grub-mkconfig -o /boot/grub/grub.cfg
```
Reboot

**Others distros**: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker

## Remap user (if needed):

Find userid and groupid for your user:
```sh
id
#example output: uid=1000(n0k0m3) gid=1001(n0k0m3) groups=1001(n0k0m3),3(sys),965(libvirt),966(docker),982(rfkill),984(users),992(kvm),993(input),998(wheel),1000(autologin)
```

We'll use `username=n0k0m3`, `uid=1000` and `gid=1001` from here (default username and usergroup)
```sh
sudo nano /etc/docker/daemon.json
```
Add this `json` to the file
```json
{
  "userns-remap": "1000:1001"
}
```
Update `subuid/gid`:
```sh
# Append sub-id to these files
echo "n0k0m3:1000:65536" >> sudo tee -a /etc/subuid
echo "n0k0m3:1001:65536" >> sudo tee -a /etc/subgid
```

Finally restart `docker` daemon:
```sh
sudo systemctl restart dockerd
```

## Run jupyter-tensorflow with port 6006 exposed for Tensorboard
Change directory to path containing jupyter folder, then run:
```sh
export JUPYTER_PATH=$(realpath jupyter)

docker run -d --gpus all \
    --name tf \
    -p 6006:6006 \
    -p 8888:8888 \
    -v $JUPYTER_PATH:/tf/notebooks \
    -v $JUPYTER_PATH/.jupyter:/root/.jupyter \
    -v $JUPYTER_PATH/.kaggle:/root/.kaggle \
    tensorflow/tensorflow:nightly-gpu-jupyter
```
You can change the build tag `nightly-gpu-jupyter` to any other support build tag on [DockerHub](https://hub.docker.com/r/tensorflow/tensorflow/tags). However I'd suggest sticking with `nightly-gpu-jupyter` or at earliest `latest-gpu-jupyter` or `latest-devel-gpu` (the latter doesn't have Jupyter Notebook)

Next time to start the container:
```sh
docker start tf
```

## Run jupyter datascience notebook from jupyter docker stack
Change directory to path containing jupyter folder, then run:
```sh
export JUPYTER_PATH=$(realpath jupyter)

docker run -d \
    --name ds \
    -p 6006:6006 \
    -p 8888:8888 \
    -v $JUPYTER_PATH:/home/jovyan/ \
    -e JUPYTER_ENABLE_LAB=yes \
    -e GRANT_SUDO=yes \
    -e RESTARTABLE=yes \
    jupyter/tensorflow-notebook
```

Next time to start the container:
```sh
docker start ds
```