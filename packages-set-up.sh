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
ROS_VOICE_ASSISTANT_NODE_LINK="https://github.com/pib-rocks/voice-assistant/archive/refs/heads/PR-312.zip"
ROS_VOICE_ASSISTANT_NODE_DIR="$ROS_WORKING_DIR/src/voice_assistant"
ROS_VOICE_ASSISTANT_NODE_ZIP="voice_assistant.zip"
#
# Ask the user if they want to install ROS2 packages
read -p "Do you want to install all pib-packages? [A]ll, [S]ome, [N]one : " install_all
if [ "$install_all" == "S" ]; then
  # Check for individual packages to install
  read -p "Install datatypes? [y]es, [n]o : " install_datatypes
  read -p "Install motors? [y]es, [n]o : " install_motors
  read -p "Install camera? [y]es, [n]o : " install_camera
  read -p "Install voice-assistant? [y]es, [n]o : " install_voice_assistant
fi
if [[ "$install_all" == "A" || ("$install_all" == "S" && "$install_datatypes" == "y") ]] ; then
  echo "Installing datatypes..."
fi
if [[ "$install_all" == "A" || ("$install_all" == "S" && "$install_motors" == "y") ]] ; then
  echo "Installing motors..."
fi
if [[ "$install_all" == "A" || ("$install_all" == "S" && "$install_camera" == "y") ]] ; then
  echo "Installing camera..."
fi
if [[ "$install_all" == "A" || ("$install_all" == "S" && "$install_voice_assistant" == "y") ]] ; then
  echo "Installing voice-assistant..."
  #
  # Setting up the voice-assistant packages
  pip3.10 install openai google-cloud-speech google-cloud-texttospeech pyaudio
  sudo apt-get install flac
  #
  curl $ROS_VOICE_ASSISTANT_NODE_LINK -L --output $ROS_WORKING_DIR/$ROS_VOICE_ASSISTANT_NODE_ZIP
  sudo unzip $ROS_WORKING_DIR/$ROS_VOICE_ASSISTANT_NODE_ZIP -d $ROS_WORKING_DIR
  sudo chmod -R 777 $ROS_WORKING_DIR/voice-assistant-PR-312
  mkdir $ROS_VOICE_ASSISTANT_NODE_DIR
  mv $ROS_WORKING_DIR/voice-assistant-PR-312/*  $ROS_VOICE_ASSISTANT_NODE_DIR
  rm -r $ROS_WORKING_DIR/voice-assistant-PR-312
  #
fi
echo "Done with installing packages."