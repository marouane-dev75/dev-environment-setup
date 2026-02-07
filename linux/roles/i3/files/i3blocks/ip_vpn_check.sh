#!/bin/bash

# Get public IP address and location information
IP_INFO=$(curl -s https://ipinfo.io/)
if [ $? -ne 0 ]; then
    echo "Error"
    echo "Error"
    echo "#FF0000"
    exit 33
fi

PUBLIC_IP=$(echo "$IP_INFO" | grep -oP '"ip": "\K[^"]+')
CITY=$(echo "$IP_INFO" | grep -oP '"city": "\K[^"]+')
COUNTRY=$(echo "$IP_INFO" | grep -oP '"country": "\K[^"]+')
LOCATION="$CITY, $COUNTRY"

# Check if using VPN
IS_VPN=false
if echo "$IP_INFO" | grep -i "country" | grep -q -i -v "FR"; then
    IS_VPN=true
fi

# Display IP address with location
echo "$PUBLIC_IP ($LOCATION)"
echo "$PUBLIC_IP"

# Set color based on VPN status
if [ "$IS_VPN" = true ]; then
#    echo "#00FF00" # Green color when VPN is active
else
    #echo "#FF0000" # Red color when VPN is not active
    #exit 33 # This makes i3blocks mark the block as urgent
fi
