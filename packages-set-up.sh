#!/bin/bash
# This script assumes:
#   - that Ubuntu Desktop 22.04.2 is installed
#   - the default-user "pib" is executing it
#   - the setup-pib.sh file has been run
#
DEFAULT_USER="pib"
USER_HOME="/home/$DEFAULT_USER"
ROS_WORKING_DIR="$USER_HOME/ros_working_dir"
#
# Installing dependencies
# Depth-AI
sudo curl -sSL https://docs.luxonis.com/install_dependencies.sh | sudo bash
python3 -m pip install depthai
# Setting up the motor packages
pip3.10 install tinkerforge
sudo apt-get install libusb-1.0-0-dev
# Setting up the voice-assistant packages
pip3.10 install openai google-cloud-speech google-cloud-texttospeech pyaudio
sudo apt-get install flac
#Git examples for Depth-AI
git clone --recurse-submodules https://github.com/luxonis/depthai-python.git
cd depthai-python/examples
python3 install_requirements.py
# Hand tracker
git clone https://github.com/geaxgx/depthai_hand_tracker.git
cd depthai_hand_tracker
pip install -r requirements.txt
#
#check on git
echo 'check if git init is done'
cd $ROS_WORKING_DIR/src
if [ ! -f .git ]; then
	git init
fi
#git pull packages with sub modules
echo 'git pull packages with sub modules'
git pull https://github.com/pib-rocks/ros-packages.git
chmod +x package_set_up.sh
git submodule init
git submodule update
echo 'Done with installing packages'
#
echo "Booting all nodes..."
# Boot camera
sudo chmod 755 $ROS_CAMERA_BOOT_DIR/ros_camera_boot.sh
sudo chmod 755 $ROS_CAMERA_BOOT_DIR/ros_camera_boot.service
sudo mv $ROS_CAMERA_BOOT_DIR/ros_camera_boot.service /etc/systemd/system
sudo systemctl enable ros_camera_boot.service
# Boot motors
sudo chmod 755 $ROS_MOTORS_BOOT_DIR/ros_motors_boot.sh
sudo chmod 755 $ROS_MOTORS_BOOT_DIR/ros_motors_boot.service
sudo mv $ROS_MOTORS_BOOT_DIR/ros_motors_boot.service /etc/systemd/system
sudo systemctl enable ros_motors_boot.service
# Boot voice-assistant
sudo chmod 755 $ROS_VOICE_ASSISTANT_BOOT_DIR/ros_voice_assistant_boot.sh
sudo chmod 755 $ROS_VOICE_ASSISTANT_BOOT_DIR/ros_voice_assistant_boot.service
sudo mv $ROS_VOICE_ASSISTANT_BOOT_DIR/ros_voice_assistant_boot.service /etc/systemd/system
sudo systemctl enable ros_voice_assistant_boot.service
