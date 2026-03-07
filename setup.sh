#!/bin/bash
# OpenBachelorC Setup Script for Android/Termux
# Equivalent of setup.cmd

echo "Setting up OpenBachelorC for Android/Termux..."

# Update package lists and upgrade existing packages
pkg upgrade -y

pkg install -y git
pkg install -y python python-pip
# pkg install -y rust
# pkg install -y binutils
pkg install -y android-tools
# pkg install -y jq
pkg install -y tsu

# Install dependencies directly using pip
echo "Installing Python dependencies..."
python -m pip install --upgrade pip
python -m pip install "prompt-toolkit>=3.0.52,<4.0.0"
python -m pip install "requests>=2.32.5,<3.0.0"
python -m pip install "pycryptodome>=3.23.0"

cd termux/ && bash build.sh

echo "Setup completed! Press Enter to continue..."
read
