#/bin/bash

# Make sure that 'xhost +' has been run before this script!!!!

sudo docker run -ti \
		--rm \
		--gpus all \
		--net=host \
		-e DISPLAY=$DISPLAY \
		-v /tmp/.X11-unix/:/tmp/.X11-unix/:rw \
		-v ~/git/MATLAB_Docker/license.lic:/licenses/license.lic -e MLM_LICENSE_FILE=/licenses/license.lic \
		-v ~/git/robotarium_matlab_backend:/home/matlab/Documents/MATLAB \
		mathworks/matlab:full
		
#-v ~/Downloads/MATLAB_r2022b:/home/matlab/Documents/MATLAB/Toolbox_Installer \
