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
ROS_CAMERA_NODE_LINK="https://github.com/pib-rocks/ros2_oak_d_lite/archive/refs/heads/PR-312.zip"
ROS_CAMERA_NODE_DIR="$ROS_WORKING_DIR/src/oak_d_lite"
ROS_CAMERA_NODE_ZIP="oak_d_lite.zip"
ROS_CAMERA_BOOT_DIR="$ROS_CAMERA_NODE_DIR/boot_scripts"
#
ROS_MOTORS_NODE_LINK="https://github.com/pib-rocks/motors/archive/refs/heads/PR-312.zip"
ROS_MOTORS_NODE_DIR="$ROS_WORKING_DIR/src/motors"
ROS_MOTORS_NODE_ZIP="motors.zip"
ROS_MOTORS_BOOT_DIR="$ROS_MOTORS_NODE_DIR/boot_scripts"
#
ROS_VOICE_ASSISTANT_NODE_LINK="https://github.com/pib-rocks/voice-assistant/archive/refs/heads/PR-312.zip"
ROS_VOICE_ASSISTANT_NODE_DIR="$ROS_WORKING_DIR/src/voice_assistant"
ROS_VOICE_ASSISTANT_NODE_ZIP="voice_assistant.zip"
ROS_VOICE_ASSISTANT_BOOT_DIR="$ROS_VOICE_ASSISTANT_NODE_DIR/boot_scripts"
#
echo "Installing ros2_oak_d_lite..."
# Setting up the camera, including AI capabilities
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
