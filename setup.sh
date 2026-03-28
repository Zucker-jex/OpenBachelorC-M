#!/bin/bash
# OpenBachelorC Setup Script for Android/Termux
# Equivalent of setup.cmd

echo "Setting up OpenBachelorC for Android/Termux..."

# Update package lists and upgrade existing packages
pkg upgrade -y

pkg install -y git python python-pip android-tools
# pkg install -y rust
# pkg install -y binutils
# pkg install -y jq

# Install dependencies directly using pip
echo "Installing Python dependencies..."
python -m pip install --upgrade pip
python -m pip install "prompt-toolkit>=3.0.52,<4.0.0"
python -m pip install "requests>=2.32.5,<3.0.0"
python -m pip install "pycryptodome>=3.23.0"

cd termux/ && bash build.sh

LOGIN_SCRIPT="$PREFIX/etc/termux-login.sh"
START_CMD="bash ~/storage/downloads/OpenBachelorC-M/start.sh"

if [ ! -f "$LOGIN_SCRIPT" ]; then
    echo "$START_CMD" > "$LOGIN_SCRIPT"
else
    grep -qxF "$START_CMD" "$LOGIN_SCRIPT" || echo "$START_CMD" >> "$LOGIN_SCRIPT"
fi

echo "Setup completed!"

# Check if user has su privilege
if ! su -c "true" >/dev/null 2>&1; then
    echo ""
    echo "========================================"
    echo "Non-root user detected. Please pair ADB using the steps below:"
    echo "========================================"
    echo ""
    echo "1. On your phone, open 'Developer options' -> 'Wireless debugging'"
    echo "2. Tap 'Pair device with pairing code' (use Termux in split-screen or floating window)"
    echo "3. IP is fixed to 127.0.0.1"
    echo ""
    read -p "Enter pairing port (usually 5555 or similar): " PAIR_PORT
    read -p "Enter pairing code (6 digits): " PAIR_CODE
    
    echo ""
    echo "Running pairing command..."
    adb pair 127.0.0.1:$PAIR_PORT <<< "$PAIR_CODE"
    
    echo ""
    echo "Pairing finished. You will be prompted to connect ADB when starting the script."
else
    echo "Root permission detected."
fi

echo ""
echo "Press Enter to continue..."
read
