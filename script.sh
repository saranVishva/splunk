#!/bin/bash

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
wget -O splunk-9.1.2-b6b9c8185839-Linux-x86_64.tgz "https://download.splunk.com/products/splunk/releases/9.1.2/linux/splunk-9.1.2-b6b9c8185839-Linux-x86_64.tgz"
mv splunk-* /opt/
cd /opt/
tar xvf splunk-*
chown -R splunker:splunker /opt/splunk

# Start Splunk
sudo  /opt/splunk/bin/splunk enable boot-start -user splunker -systemd-managed 1
sudo -u splunker /opt/splunk/bin/splunk start