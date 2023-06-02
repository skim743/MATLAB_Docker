# Running the official MATLAB Docker container with a license file
1. Go to https://www.mathworks.com/licensecenter
2. Select a license file (ex. 621625 (GT MATLAB license))
3. Click 'Install and Activate'
4. Click 'Activate to Retrieve License File’ under ‘RELATED TASKS'
5. Click 'Activate a Computer'
6. Fill out the blanks as the attached screen capture
7. Select 'Yes' when asked if the software is installed and click 'Continue'
8. Click 'Download License File' to a desired directory
9. Run the docker with
  ```
	docker run -it --rm -v /absolute-path-to-the-license-file/license.lic:/licenses/license.lic -e MLM_LICENSE_FILE=/licenses/license.lic mathworks/matlab:<version>
  ```
  (ex. docker run docker run -it --rm -v ~/git/MATLAB_Docker/license.lic:/licenses/license.lic -e MLM_LICENSE_FILE=/licenses/license.lic mathworks/matlab:r2022a)

# Creating a MATLAB container with all toolboxes
1. Download products without installing by following through the instructions in https://www.mathworks.com/help/install/ug/download-without-installing.html until Step 5.
  - As soon as selecting the license (ex. 621625) and clicking 'Next,' click 'Advanced Options' on the top right corner of the installation window. Then, click 'I want to download without installing.'
  - In Step 4, select all toolboxes and uncheck MATLAB since we are only installing toolboxes on the top of the official docker image. Click 'Don’t add' when it prompts to add MATLAB.
2. Add '-v /path-to-the-installer-folder:/home/matlab/Documents/MATLAB/Toolbox_Intaller \' to 'docker_run.sh'
  (ex. -v ~/Downloads/MATLAB_r2022b:/home/matlab/Documents/MATLAB/Toolbox_Installer \)
3. In 'docker_run.sh,' change the last line from 'mathworks/matlab:full' to 'mathworks/matlab:<version>'
4. Run './docker_run.sh'- This should start the MATLAB with GUI
5. Open another terminal and run 'sudo docker exec -it matlab_container_id /bin/bash'
  - The container ID can be found by running the command
  ```
  sudo docker ps -a
  ```
6. In the second terminal, run 'sudo cp -f /opt/matlab/<MATLAB-version>/VersionInfo.xml /home/matlab/Documents/MATLAB/Toolbox_Installer/<MATLAB-version>/the-only-folder-named-with-date/VersionInfo.xml'
(ex. sudo cp -f /opt/matlab/R2022a/VersionInfo.xml /home/matlab/Documents/MATLAB/Toolbox_Installer/R2022a/2023_03_13_21_42_01/VersionInfo.xml)
  - This is a workaround to match the version of the MATLAB in the container and the version of the Toolbox to be installed. Without this step, the installer will throw an error, "To proceed you must select a destination with the following products installed: MATLAB.”
7. Run 
```
sudo ./Toolbox_Installer/<MATLAB-version>/the-only-folder-named-with-date/install
```
and complete the installation process
  - Log into MATLAB account and select the MATLAB license (ex. 621625) as usual- When prompted to enter 'Login Name,' type 'matlab'
  - When prompted to 'Select destination folder,' type '/opt/matlab/<MATLAB-version>'
8. Don’t forget to commit the Docker after the installation
```
sudo docker commit container-id mathworks/matlab:full
```
9. In 'docker_run.sh,' remove '-v /path-to-the-installer-folder:/home/matlab/Documents/MATLAB/Toolbox_Intaller \' and add '-v <path-to-local-directory>:/home/matlab/Documents/MATLAB \'
	(ex. -v ~/git/robotarium_matlab_backend:/home/matlab/Documents/MATLAB \ )
10. In 'docker_run.sh,' change the last line from 'mathworks/matlab:<version>' to 'mathworks/matlab:full'

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
