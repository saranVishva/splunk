#!/bin/bash
echo "SPLUNK INSTALLER"

# Username and password
username="splunk"
password="password"

# Create the user if it doesn't exist
if ! id "$username" &>/dev/null; then
    sudo useradd -m -s /bin/bash "$username"
    echo "$username:$password" | sudo chpasswd
    echo "User $username created with password: $password"
else
    echo "User $username already exists."
fi

# Install Splunk
echo "Downloading Splunk installer..."
sudo wget -O /tmp/splunk-9.1.2-b6b9c8185839-Linux-x86_64.tgz "https://download.splunk.com/products/splunk/releases/9.1.2/linux/splunk-9.1.2-b6b9c8185839-Linux-x86_64.tgz"

# Switch to splunk user and install
cd /opt/
sudo tar xvf /tmp/splunk-9.1.2-b6b9c8185839-Linux-x86_64.tgz
sudo chown -R "$username:$username" /opt/splunk
command_to_execute="/opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt"
sudo -u "$username" bash -c "$command_to_execute"
echo "Splunk installed under user $username."
