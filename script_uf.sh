#!/bin/bash

echo" ____  ____   _____        _______ ____"
echo"/ ___||  _ \ / _ \ \      / / ____|  _ \"
echo"\___ \| |_) | | | \ \ /\ / /|  _| | |_) |"
echo" ___) |  __/| |_| |\ V  V / | |___|  _ <"
echo"|____/|_|    \___/  \_/\_/  |_____|_| \_\"

echo "SPLUNK INSTALLER   - BY SPOWER"

# Function to check if user exists
user_exists() {
    id "$1" &>/dev/null
}

# Check if user 'splunker' exists, if not, create it
if ! user_exists splunker; then
    echo "User 'splunker' does not exist. Creating user..."
    adduser splunker
    passwd splunker
    if [ $? -ne 0 ]; then
        echo "Failed to create user 'splunker'. Exiting."
        exit 1
    fi
    echo "User 'splunker' created successfully."
fi

# Install Splunk
echo "Downloading Splunk installer..."
wget -O splunkforwarder-9.2.0-1fff88043d5f-Linux-x86_64.tgz "https://download.splunk.com/products/universalforwarder/releases/9.2.0/linux/splunkforwarder-9.2.0-1fff88043d5f-Linux-x86_64.tgz"
mv splunk* /opt/
cd /opt/
tar xvf splunk*
chown -R splunker:splunker /opt/splunkforwarder

# Start Splunk
sudo  /opt/splunkforwarder/bin/splunk enable boot-start -user splunker -systemd-managed 1
sudo -u splunker /opt/splunkforwarder/bin/splunk start --accept-license