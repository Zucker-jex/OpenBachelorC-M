#!/bin/bash
echo "Setting up OpenBachelorS for Android/Termux..."

pkg upgrade -y

pkg install -y git python python-pip rust binutils aria2 postgresql

export ANDROID_API_LEVEL=$(getprop ro.build.version.sdk)

python -m pip install pathvalidate requests pycryptodome click prompt-toolkit psycopg psycopg-pool fastapi uvicorn pytest-asyncio hypercorn aiofiles httpx orjson truststore

echo "Setup completed! Press Enter to continue..."
read
