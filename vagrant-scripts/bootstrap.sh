#!/usr/bin/env bash

sudo -u vagrant echo "export WORKSPACE='/workspace/'" >> /home/vagrant/.bashrc
sudo -u vagrant echo "cd /workspace" >> /home/vagrant/.bashrc
sudo -u vagrant echo "source /opt/ros/humble/setup.bash" >> /home/vagrant/.bashrc

# Enable X11 Forwarding
# echo "X11Forwarding yes" >> /etc/ssh/sshd_config
# echo "export LIBGL_ALWAYS_INDIRECT=1" >> /home/vagrant/.bashrc
# Note: if using LIBGL_ALWAYS_INDIRECT=1, rviz2 does not run! (Failed to create an OpenGL context)

mkdir /workspace/
chown -R vagrant /workspace/

apt update

# setup GNOME desktop
apt install -y ubuntu-desktop

#apt install -y \
#  virtualbox-guest-dkms \
#  virtualbox-guest-utils \
#  virtualbox-guest-x11

# Install ROS1
#sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
#apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
#apt-get update
#apt-get install -y ros-noetic-desktop-full ros-noetic-moveit python3-catkin-tools python3-catkin-lint python3-rosdep python3-roslaunch \
#  ros-noetic-moveit-visual-tools ros-noetic-dynamixel-sdk
#apt-get install -y gitg vim meld terminator

#rosdep init
#rosdep fix-permissions

# sudo -u vagrant rosdep update

# Preparations to install ROS2
apt install -y curl \
  gnupg2 lsb-release \
  software-properties-common

add-apt-repository -y universe
#Adding ROS2 GPG key
sudo apt update && sudo apt install curl gnupg lsb-release
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
#Adding the repository to sources list
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

# add-apt-repository ppa:deadsnakes/ppa
#   python3.7 \

apt update
apt upgrade

apt install -y \
  build-essential \
  cmake \
  git \
  libyaml-cpp-dev \
  libbullet-dev \
  python3-colcon-common-extensions \
  python3-flake8 \
  python3-pip \
  python3-pytest-cov \
  python3-rosdep \
  python3-setuptools \
  python3-vcstool \
  python3-keras \
  wget
# install some pip packages needed for testing
python3 -m pip install -U \
  argcomplete \
  flake8-blind-except \
  flake8-builtins \
  flake8-class-newline \
  flake8-comprehensions \
  flake8-deprecated \
  flake8-docstrings \
  flake8-import-order \
  flake8-quotes \
  pytest-repeat \
  pytest-rerunfailures \
  pytest\
  diagrams
# install Fast-RTPS dependencies
apt install --no-install-recommends -y \
  libasio-dev \
  libtinyxml2-dev
# install Cyclone DDS dependencies
apt install --no-install-recommends -y \
  libcunit1-dev

# Install ROS2 Humble
apt install -y \
  ros-humble-desktop \
  ros-humble-dynamixel-sdk

#Try to install python3-keras already here, because it often fails with rosdep...
#apt install -y python3-keras
#python3-keras not available in 22.04, so install requirements with pip
python3 -m pip install -U \
 #keras \
 tensorflow-cpu #CPU version of the tensorflow, install tensorflow if both cpu and gpu is needed

# curl -L -o /tmp/ros2-foxy.tar.bz2 https://github.com/ros2/ros2/releases/download/release-foxy-20201211/ros2-foxy-20201211-linux-focal-amd64.tar.bz2

# mkdir -p /ros2_foxy
# cd /ros2_foxy

# tar -xf /tmp/ros2-foxy.tar.bz2 -C /ros2_foxy
# rm /tmp/ros2-foxy.tar.bz2

# chown -R vagrant /ros2_foxy/

# sudo -u vagrant rosdep update
# sudo -u vagrant rosdep install --from-paths ros2-linux/share --ignore-src --rosdistro foxy -y --skip-keys "console_bridge fastcdr fastrtps osrf_testing_tools_cpp poco_vendor rmw_connext_cpp rosidl_typesupport_connext_c rosidl_typesupport_connext_cpp rti-connext-dds-5.3.1 tinyxml_vendor tinyxml2_vendor urdfdom urdfdom_headers"

# Setup Dynamixel U2D2 (https://emanual.robotis.com/docs/en/software/dynamixel/dynamixel_workbench/#u2d2)
wget https://raw.githubusercontent.com/ROBOTIS-GIT/dynamixel-workbench/master/99-dynamixel-workbench-cdc.rules -P /etc/udev/rules.d/
udevadm control --reload-rules
udevadm trigger

# Change python3 symlink from python3.8 to python3.7 (ROS2 does not work with python 3.8 currently)
# rm /usr/bin/python3
# ln -s /usr/bin/python3.7 /usr/bin/python3

# Clone submodules
cd /workspace && git submodule update --init --recursive
#cd /workspace/src/
#git clone https://github.com/ROBOTIS-GIT/dynamixel-workbench.git
#git clone https://github.com/ROBOTIS-GIT/dynamixel-workbench-msgs.git
#cd /workspace/src/dynamixel-workbench/
#git checkout humble-devel
#cd /workspace/src/dynamixel-workbench-msgs/
#git checkout humble-devel

source /opt/ros/humble/setup.bash

# Install package dependencies
apt install -y \
  ros-humble-test-msgs \
  ros-humble-control-msgs \
  ros-humble-realtime-tools \
  ros-humble-xacro \
  ros-humble-angles \
  v4l-utils
  ros-humble-diagnostic-updater

# Install ros2_control (https://github.com/ros-controls/ros2_control)

#mkdir -p /ros2_control_ws/src
#cd /ros2_control_ws

# Making custom repo file to pull Humble versions
#vcs import src < /workspace/vagrant-scripts/ros2_control_ws.repos_humble.yml
#colcon build

#source /ros2_control_ws/install/setup.bash
#sudo -u vagrant echo "source /ros2_control_ws/install/setup.bash" >> /home/vagrant/.bashrc

#We'll install the humble versions using apt instead
apt install -y \
  ros-humble-ros2-control \
  ros-humble-ros2-controllers \
  ros-humble-control-msgs \
  ros-humble-control-toolbox

# Allow access to shared folders
adduser vagrant vboxsf

# Install opencv_cam (https://github.com/clydemcqueen/opencv_cam)
# Seems like requires foxy and no newly changed stuff
mkdir -p /opencv_cam_ws/src
cd /opencv_cam_ws/src
git clone https://github.com/clydemcqueen/opencv_cam.git
# Checkout specific commit of ros2_shared
git clone https://github.com/ptrmu/ros2_shared.git
cd ros2_shared
git checkout 02433ef4f873876c3dd3ab2925987cf04d224660
cd ..

rosdep init
rosdep update
rosdep install --from-paths src --ignore-src --rosdistro humble -r -y

colcon build
source /opencv_cam_ws/install/setup.bash
sudo -u vagrant echo "source /opencv_cam_ws/install/setup.bash" >> /home/vagrant/.bashrc

python3 -m pip install opencv-python dlib

# Install workspace package dependencies
cd /workspace
rosdep install --from-paths src --ignore-src --rosdistro humble -r -y

# Enable sourcing of built ros2 environment to bash configuration
echo "source install/setup.bash" >> /home/vagrant/.bashrc

# Enable colcon autocomplete
echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> /home/vagrant/.bashrc

reboot

