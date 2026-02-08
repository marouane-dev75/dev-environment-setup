#!/bin/bash
# SwiftBar Memory Monitor
# <swiftbar.refreshOnOpen>true</swiftbar.refreshOnOpen>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>

# Get memory statistics
PAGE_SIZE=$(pagesize)
VM_STAT=$(vm_stat)

# Extract values
PAGES_FREE=$(echo "$VM_STAT" | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
PAGES_ACTIVE=$(echo "$VM_STAT" | grep "Pages active" | awk '{print $3}' | sed 's/\.//')
PAGES_INACTIVE=$(echo "$VM_STAT" | grep "Pages inactive" | awk '{print $3}' | sed 's/\.//')
PAGES_SPECULATIVE=$(echo "$VM_STAT" | grep "Pages speculative" | awk '{print $3}' | sed 's/\.//')
PAGES_WIRED=$(echo "$VM_STAT" | grep "Pages wired down" | awk '{print $4}' | sed 's/\.//')

# Calculate memory in GB
FREE_MEM=$(echo "scale=2; ($PAGES_FREE * $PAGE_SIZE) / 1073741824" | bc)
USED_MEM=$(echo "scale=2; (($PAGES_ACTIVE + $PAGES_INACTIVE + $PAGES_WIRED) * $PAGE_SIZE) / 1073741824" | bc)
TOTAL_MEM=$(sysctl -n hw.memsize | awk '{print $1/1073741824}')

# Calculate percentage (using awk for better precision)
MEM_PERCENT=$(awk "BEGIN {printf \"%.0f\", ($USED_MEM / $TOTAL_MEM) * 100}")

# Choose icon based on usage
if [ "$MEM_PERCENT" -lt 50 ]; then
    ICON="🟢"
elif [ "$MEM_PERCENT" -lt 80 ]; then
    ICON="🟡"
else
    ICON="🔴"
fi

# Display in menu bar
printf "%s MEM %02d%%\n" "$ICON" "$MEM_PERCENT"
echo "---"

# Detailed information
echo "Memory Usage: ${MEM_PERCENT}%"
printf "Used: %.2f GB / %.0f GB\n" "$USED_MEM" "$TOTAL_MEM"
printf "Free: %.2f GB\n" "$FREE_MEM"
echo "---"

# Top memory consuming processes
echo "Top Memory Processes:"
top -l 1 -n 5 -o mem -stats pid,command,mem | tail -n +12 | head -n 5
