#!/bin/bash
# SwiftBar Network/VPN Monitor
# <swiftbar.refreshOnOpen>true</swiftbar.refreshOnOpen>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>

# Get public IP address and location information
IP_INFO=$(curl -s --max-time 5 https://ipinfo.io/)
if [ $? -ne 0 ]; then
    echo "🔴 Network Error"
    echo "---"
    echo "Failed to fetch IP information"
    exit 0
fi

PUBLIC_IP=$(echo "$IP_INFO" | grep -oE '"ip": "[^"]+"' | cut -d'"' -f4)
CITY=$(echo "$IP_INFO" | grep -oE '"city": "[^"]+"' | cut -d'"' -f4)
COUNTRY=$(echo "$IP_INFO" | grep -oE '"country": "[^"]+"' | cut -d'"' -f4)
ORG=$(echo "$IP_INFO" | grep -oE '"org": "[^"]+"' | cut -d'"' -f4)

# List of known VPN providers (case-insensitive)
VPN_PROVIDERS="datacamp|nordvpn|expressvpn|protonvpn|surfshark|mullvad|privateinternetaccess|pia|cyberghost|ipvanish|tunnelbear|windscribe|vyprvpn|purevpn|hotspot shield"

# Check if using VPN based on organization
IS_VPN=false
VPN_ICON="🔴"
if echo "$ORG" | grep -E -i -q "$VPN_PROVIDERS"; then
    IS_VPN=true
    VPN_ICON="🟢"
fi

# Get local IP
LOCAL_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1)

# Display in menu bar
if [ "$IS_VPN" = true ]; then
    echo "$VPN_ICON VPN: $PUBLIC_IP"
else
    echo "$VPN_ICON $PUBLIC_IP"
fi

echo "---"
echo "Public IP: $PUBLIC_IP"
echo "Local IP: $LOCAL_IP"
echo "Location: $CITY, $COUNTRY"
echo "Provider: $ORG"
echo "---"
if [ "$IS_VPN" = true ]; then
    echo "✅ VPN Active"
else
    echo "⚠️ VPN Inactive"
fi
