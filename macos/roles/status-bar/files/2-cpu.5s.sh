#!/bin/bash
# SwiftBar CPU Monitor
# <swiftbar.refreshOnOpen>true</swiftbar.refreshOnOpen>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>

# Get CPU usage using top command
CPU_USAGE=$(top -l 2 -n 0 -F | grep "CPU usage" | tail -1 | awk '{print $3}' | sed 's/%//')

# Round to integer
CPU_INT=$(printf "%.0f" "$CPU_USAGE")

# Choose icon based on usage
if [ "$CPU_INT" -lt 30 ]; then
    ICON="🟢"
elif [ "$CPU_INT" -lt 70 ]; then
    ICON="🟡"
else
    ICON="🔴"
fi

# Display in menu bar
printf "%s CPU %02d%%\n" "$ICON" "$CPU_INT"
echo "---"

# Get detailed CPU info
CPU_INFO=$(top -l 1 -n 0 -F | grep "CPU usage")
echo "CPU Usage Details"
echo "$CPU_INFO"
echo "---"

# Get per-core usage
echo "Top Processes:"
top -l 1 -n 5 -o cpu -stats pid,command,cpu | tail -n +12 | head -5
