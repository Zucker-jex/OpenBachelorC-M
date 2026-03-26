#!/data/data/com.termux/files/usr/bin/bash

# Define variables
CONFIG_FILE="$HOME/storage/downloads/OpenBachelorC-M/conf/config.json"
SERVER_START_SCRIPT="$HOME/storage/downloads/OpenBachelorS/start.sh"
TMUX_CMD="tmux new-session -d -s service1 'sh $SERVER_START_SCRIPT'"
CLIENT_MAIN_SCRIPT="$HOME/storage/downloads/OpenBachelorC-M/main.sh"
HOST="10.0.0.1"

# Stop the server
stop_obs() {
    if tmux has-session -t service1 2>/dev/null; then
        echo "Stopping OBS server (tmux session service1)..."
        tmux kill-session -t service1
        echo "OBS server stopped."
    else
        echo "No running OBS server detected."
    fi
}

# Check if configuration file exists (required)
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Configuration file not found at $CONFIG_FILE"
    exit 1
fi

# Check if server start script exists
if [ -f "$SERVER_START_SCRIPT" ]; then
    # ========== Server exists: Show O/F/N options ==========
    echo "Please select run mode:"
    echo "  O - Online mode"
    echo "  F - Offline mode"
    echo "  N - Exit script"
    read -p "[O/F/N]: " mode

    case "$mode" in
        O|o|Online|online)
            echo "Online mode: Not starting local OBS, setting host to $HOST"
            sed -i "s/\"host\": *\"[^\"]*\"/\"host\": \"$HOST\"/" "$CONFIG_FILE"
            ;;
        F|f|Offline|offline)
            echo "Offline mode: Starting local OBS, setting host to 127.0.0.1 and starting server..."
            sed -i 's/"host": *"[^"]*"/"host": "127.0.0.1"/' "$CONFIG_FILE"
            eval "$TMUX_CMD"
            echo "Server started in tmux session 'service1'"
            ;;
        N|n|No|no)
            echo "Exiting script."
            exit 0
            ;;
        *)
            echo "Invalid input"
            exit 1
            ;;
    esac
else
    # ========== Server does not exist: Show Y/N options ==========
    echo "Do you want to start OBC?"
    read -p "[Y/N]: " yn

    case "$yn" in
        Y|y|Yes|yes)
            echo "Setting host to $HOST"
            sed -i "s/\"host\": *\"[^\"]*\"/\"host\": \"$HOST\"/" "$CONFIG_FILE"
            ;;
        N|n|No|no)
            echo "Exiting script."
            exit 0
            ;;
        *)
            echo "Invalid input"
            exit 1
            ;;
    esac
fi

# ========== ADB network configuration ==========
echo "Configuring ADB network..."
tsu -s "setprop service.adb.tcp.port 5555"
tsu -s "stop adbd"
tsu -s "start adbd"

# Wait for ADB service to start
sleep 2

# ========== Start OBC ==========
echo "Starting OBC..."
cd "$HOME/storage/downloads/OpenBachelorC-M/" && sh "$CLIENT_MAIN_SCRIPT"