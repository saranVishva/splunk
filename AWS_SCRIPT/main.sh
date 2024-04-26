#!/bin/bash
# Default Key Name
KEY_ID="Positka"

# Default Security Group ID #positka
SECURITY_GROUP_ID="sg-051a9de11c4e5e091" 

# Default Subnet ID #positka
SUBNET_ID="subnet-0a91558a34cf3ef61"

# Default AWS Region
REGION="ap-south-1"

#Default AMI ID
AMI_ID="ami-007020fd9c84e18c7"

# Default instance type
INSTANCE_TYPE="t2.medium"

# Prompt user for Owner Name
read -p "Enter Owner Name: " OWNER_NAME

# Prompt user for Name tag
read -p "Enter Instance Name: " NAME

# Prompt user for Number of Instances
read -p "Enter Number of Instances: " COUNT

# Prompt user for Project Type
echo "Select Project Type:"
echo "1. MNC"
echo "2. Non-MNC"
echo "3. Splunk"
read -p "Enter your choice : " CHOICE

# Set default tag value for Project
PROJECT_TAG=""

# Switch case for Project type
case $CHOICE in
    1)
        PROJECT_TAG="mnc_support"
        ;;
    2)
        PROJECT_TAG="non_mnc_support"
        ;;
    3)
        PROJECT_TAG="splunk_support"
        ;;
    *)
        echo "Invalid choice entered. Defaulting to empty Project tag."
        ;;
esac

# Run AWS CLI command to create instance and retrieve instance ID(s)
INSTANCE_IDS=$(aws ec2 run-instances \
    --region $REGION \
    --image-id $AMI_ID \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_ID \
    --security-group-ids $SECURITY_GROUP_ID \
    --subnet-id $SUBNET_ID \
    --count $COUNT \
    --block-device-mappings "[{\"DeviceName\":\"/dev/sda1\",\"Ebs\":{\"VolumeSize\":30}}]" \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Owner,Value='$OWNER_NAME'},{Key=Name,Value='$NAME'},{Key=Project,Value='$PROJECT_TAG'}]' \
    --user-data file://splunk_installer.sh \
    --query 'Instances[].InstanceId' \
    --output text)

# Loop through each instance ID
for INSTANCE_ID in $INSTANCE_IDS; do
    # Retrieve attached volume IDs
    VOLUME_IDS=$(aws ec2 describe-instances \
        --region $REGION \
        --instance-ids $INSTANCE_ID \
        --query 'Reservations[].Instances[].BlockDeviceMappings[].Ebs.VolumeId' \
        --output text)

    # Tag each volume with the instance name
    for VOLUME_ID in $VOLUME_IDS; do
        aws ec2 create-tags \
            --region $REGION \
            --resources $VOLUME_ID \
            --tags Key=Owner,Value=$OWNER_NAME Key=Name,Value=$NAME
    done
done
