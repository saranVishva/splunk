#!/bin/bash
echo "SPLUNK INSTALLER"

# Check if the script is executed with root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Username and password
username="splunk"
password="password"

# Install Splunk
echo "Downloading Splunk installer..."
wget -O /tmp/splunk-9.1.2-b6b9c8185839-Linux-x86_64.tgz "https://download.splunk.com/products/splunk/releases/9.1.2/linux/splunk-9.1.2-b6b9c8185839-Linux-x86_64.tgz"

# Switch to splunk user and install
su - "$username" <<EOF
cd /opt/
tar xvf /tmp/splunk-9.1.2-b6b9c8185839-Linux-x86_64.tgz
chown -R "$username:$username" /opt/splunk
/opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd "$password"
EOF

echo "Splunk installed under user $username."
