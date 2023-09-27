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
ROS_CAMERA_NODE_LINK="https://github.com/Lisa-isento/ros2_oak_d_lite/archive/refs/heads/PR-312.zip"
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
#Git examples for Depth-AI
git clone --recurse-submodules https://github.com/luxonis/depthai-python.git
cd depthai-python/examples
python3 install_requirements.py
# Hand tracker
git clone https://github.com/geaxgx/depthai_hand_tracker.git
cd depthai_hand_tracker
pip install -r requirements.txt
#
# Downloading files for camera
curl $ROS_CAMERA_NODE_LINK -L --output $ROS_WORKING_DIR/$ROS_CAMERA_NODE_ZIP
sudo unzip $ROS_WORKING_DIR/$ROS_CAMERA_NODE_ZIP -d $ROS_WORKING_DIR
sudo chmod -R 777 $ROS_WORKING_DIR/ros2_oak_d_lite-PR-312
mkdir $ROS_CAMERA_NODE_DIR
mv $ROS_WORKING_DIR/ros2_oak_d_lite-PR-312/*  $ROS_CAMERA_NODE_DIR
rm -r $ROS_WORKING_DIR/ros2_oak_d_lite-PR-312
#
echo "Installing motors..."
# Setting up the motor packages
pip3.10 install tinkerforge
sudo apt-get install libusb-1.0-0-dev
#
# Downloading files for voice-assistant
curl $ROS_MOTORS_NODE_LINK -L --output $ROS_WORKING_DIR/$ROS_MOTORS_NODE_ZIP
sudo unzip $ROS_WORKING_DIR/$ROS_MOTORS_NODE_ZIP -d $ROS_WORKING_DIR
sudo chmod -R 777 $ROS_WORKING_DIR/motors-PR-312
mkdir $ROS_MOTORS_NODE_DIR
mv $ROS_WORKING_DIR/motors-PR-312/*  $ROS_MOTORS_NODE_DIR
rm -r $ROS_WORKING_DIR/motors-PR-312
#
echo "Installing voice-assistant..."
# Setting up the voice-assistant packages
pip3.10 install openai google-cloud-speech google-cloud-texttospeech pyaudio
sudo apt-get install flac
#
# Downloading files for voice-assistant
curl $ROS_VOICE_ASSISTANT_NODE_LINK -L --output $ROS_WORKING_DIR/$ROS_VOICE_ASSISTANT_NODE_ZIP
sudo unzip $ROS_WORKING_DIR/$ROS_VOICE_ASSISTANT_NODE_ZIP -d $ROS_WORKING_DIR
sudo chmod -R 777 $ROS_WORKING_DIR/voice-assistant-PR-312
mkdir $ROS_VOICE_ASSISTANT_NODE_DIR
mv $ROS_WORKING_DIR/voice-assistant-PR-312/*  $ROS_VOICE_ASSISTANT_NODE_DIR
rm -r $ROS_WORKING_DIR/voice-assistant-PR-312
#
# build all packages
cd $ROS_WORKING_DIR
sudo colcon build
source install/setup.bash
#
echo "Booting all nodes..."
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
#
echo "source /home/pib/ros_working_dir/install/setup.bash" >> ~/.bashrc
#
echo "Done with installing packages."