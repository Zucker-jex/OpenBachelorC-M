#!/usr/bin/env bash

# Check if version is provided as argument
if [ -z "$1" ]; then
    echo "Usage: $0 <frida-version>"
    echo "Example: $0 17.0.7"
    echo "Example: $0 16.5.9"
    exit 1
fi

FRIDA_VERSION_ARG="$1"

if ! command -v termux-setup-storage &>/dev/null; then
  echo "This script can be executed only on Termux"
  exit 1
fi

# Detect architecture
case "$(uname -m)" in
    aarch64)
        arch="arm64"
        ;;
    armv7l | armv8l)
        arch="arm"
        ;;
    x86_64)
        arch="x86_64"
        ;;
    x86)
        arch="x86"
        ;;
    *)
        echo "System architecture not recognized: $(uname -m)"
        exit 1
        ;;
esac

cd $TMPDIR || exit 1

# Update and install required packages
apt update && pkg upgrade -y
pkg i -y python git curl && pip install -U setuptools

# Use the specified Frida version
FRIDA_VERSION="$FRIDA_VERSION_ARG"
echo "Installing Frida version: $FRIDA_VERSION"

# Download Frida devkit for specified version
DEVKIT_URL="https://github.com/Alexjr2/Frida_Termux_Installation/releases/download/$FRIDA_VERSION/frida-core-devkit-android-$arch.tar.xz"
DEVKIT_FILE="frida-core-devkit-android-$arch.tar.xz"

echo "Downloading Frida devkit from: $DEVKIT_URL"
if ! curl -L -o "$DEVKIT_FILE" "$DEVKIT_URL"; then
    echo "Error: Failed to download Frida devkit."
    rm -f "$DEVKIT_FILE"  # Clean up partial download
    exit 1
fi

# Check if download was successful (file exists and has content)
if [ ! -f "$DEVKIT_FILE" ] || [ ! -s "$DEVKIT_FILE" ]; then
    echo "Error: Unable to download Frida devkit or file is empty. Please check if version $FRIDA_VERSION exists."
    echo "Please confirm the version at: https://github.com/Alexjr2/Frida_Termux_Installation/releases"
    rm -f "$DEVKIT_FILE"  # Clean up empty file
    exit 1
fi

# Clean up any existing devkit directory
if [ -d "devkit" ]; then
    echo "Cleaning up existing devkit directory..."
    rm -rf devkit
fi

# Extract devkit
mkdir -p devkit && tar -xJvf "$DEVKIT_FILE" -C devkit

# Clean up any existing frida-python directory
if [ -d "frida-python" ]; then
    echo "Cleaning up existing frida-python directory..."
    rm -rf frida-python
fi

# Clone and install Frida Python with specified version
echo "Cloning frida-python version: $FRIDA_VERSION"
if ! git clone -b "$FRIDA_VERSION" --depth 1 https://github.com/frida/frida-python.git; then
    echo "Error: Unable to clone frida-python version $FRIDA_VERSION. Please check if the version number is correct."
    echo "Please confirm the version $FRIDA_VERSION exists at https://github.com/frida/frida-python/releases"
    exit 1
fi

# fix setup.py
cd frida-python || exit 1
curl -LO https://raw.githubusercontent.com/Alexjr2/Frida_Termux_Installation/refs/heads/main/frida-python.patch
patch -p1 < frida-python.patch

#install frida-python
echo "Installing Frida Python version $FRIDA_VERSION..."
if FRIDA_VERSION="$FRIDA_VERSION" FRIDA_CORE_DEVKIT="$PWD/../devkit" pip install --force-reinstall .; then
    echo "Successfully installed Frida Python version $FRIDA_VERSION!"
    echo "You can now use: import frida in Python"
else
    echo "Error: Frida Python installation failed."
fi