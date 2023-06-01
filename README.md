# Enabling GPUs in the MATLAB docker container

The '--gpus all \' flag in 'docker_run.sh' allows the MATLAB container to access GPUs on the host computer. Follow the instruction below to set up the host computer to enable GPUs in the MATLAB container. The flag can be removed if no GPUs are needed.

# 1 - Install Nvidia driver
Check if an Nvidia driver is installed by running
```
nvidia-smi
```

If the information about the current GPU is not displayed properly, an Nvidia driver is not installed. Check the list of Nvidia drivers with
```
ubuntu-drivers devices
```
and install a driver using
```
sudo apt install nvidia-driver-<version>
```
Geforce RTX 3080 Ti empirically works fine with nvidia-driver-470

# 2 - Install Nvidia container toolkit
Check if Nvidia container toolkit is installed by running
```
nvidia-ctk
```

If the command is not recognized, it is not installed.

Nvidia container toolkit can be installed by running
```
curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker

```
