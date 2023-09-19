#!/bin/bash

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
fi

echo "Done with installing packages."