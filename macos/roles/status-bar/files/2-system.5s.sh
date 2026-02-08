#!/bin/bash
# SwiftBar System Monitor (CPU + Memory)
# <swiftbar.refreshOnOpen>true</swiftbar.refreshOnOpen>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>

# ============================================
# CPU MONITORING
# ============================================

# Get CPU usage using top command
CPU_USAGE=$(top -l 2 -n 0 -F | grep "CPU usage" | tail -1 | awk '{print $3}' | sed 's/%//')

# Round to integer
CPU_INT=$(printf "%.0f" "$CPU_USAGE")

# Choose icon based on usage
if [ "$CPU_INT" -lt 30 ]; then
    CPU_ICON="🟢"
elif [ "$CPU_INT" -lt 70 ]; then
    CPU_ICON="🟡"
else
    CPU_ICON="🔴"
fi

# ============================================
# MEMORY MONITORING
# ============================================

# Get memory statistics
PAGE_SIZE=$(pagesize)
VM_STAT=$(vm_stat)

# Extract values (matching Activity Monitor's calculation)
PAGES_FREE=$(echo "$VM_STAT" | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
PAGES_ACTIVE=$(echo "$VM_STAT" | grep "Pages active" | awk '{print $3}' | sed 's/\.//')
PAGES_INACTIVE=$(echo "$VM_STAT" | grep "Pages inactive" | awk '{print $3}' | sed 's/\.//')
PAGES_SPECULATIVE=$(echo "$VM_STAT" | grep "Pages speculative" | awk '{print $3}' | sed 's/\.//')
PAGES_WIRED=$(echo "$VM_STAT" | grep "Pages wired down" | awk '{print $4}' | sed 's/\.//')
PAGES_COMPRESSED=$(echo "$VM_STAT" | grep "Pages occupied by compressor" | awk '{print $5}' | sed 's/\.//')
PAGES_FILE_BACKED=$(echo "$VM_STAT" | grep "File-backed pages" | awk '{print $3}' | sed 's/\.//')

# Calculate memory in GB
# Activity Monitor formula: (Active + Wired - File-backed) + Compressed
# This excludes cached files that can be instantly freed
APP_MEMORY_PAGES=$((PAGES_ACTIVE + PAGES_WIRED - PAGES_FILE_BACKED + PAGES_COMPRESSED))
USED_MEM=$(echo "scale=2; ($APP_MEMORY_PAGES * $PAGE_SIZE) / 1073741824" | bc)

# Calculate available memory (Free + Inactive + Speculative + Purgeable)
PAGES_PURGEABLE=$(echo "$VM_STAT" | grep "Pages purgeable" | awk '{print $3}' | sed 's/\.//')
AVAILABLE_PAGES=$((PAGES_FREE + PAGES_INACTIVE + PAGES_SPECULATIVE + PAGES_PURGEABLE))
FREE_MEM=$(echo "scale=2; ($AVAILABLE_PAGES * $PAGE_SIZE) / 1073741824" | bc)

TOTAL_MEM=$(sysctl -n hw.memsize | awk '{print $1/1073741824}')

# Calculate percentage (using awk for better precision)
MEM_PERCENT=$(awk "BEGIN {printf \"%.0f\", ($USED_MEM / $TOTAL_MEM) * 100}")

# Choose icon based on usage
if [ "$MEM_PERCENT" -lt 50 ]; then
    MEM_ICON="🟢"
elif [ "$MEM_PERCENT" -lt 80 ]; then
    MEM_ICON="🟡"
else
    MEM_ICON="🔴"
fi

# ============================================
# DISPLAY IN MENU BAR
# ============================================

printf "%s CPU %02d%% • %s MEM %02d%%\n" "$CPU_ICON" "$CPU_INT" "$MEM_ICON" "$MEM_PERCENT"
echo "---"

# ============================================
# CPU DETAILS DROPDOWN
# ============================================

echo "💻 CPU USAGE"
# Get detailed CPU info
CPU_INFO=$(top -l 1 -n 0 -F | grep "CPU usage")
echo "$CPU_INFO"
echo ""
echo "Top CPU Processes:"
top -l 1 -n 5 -o cpu -stats pid,command,cpu | tail -n +12 | head -5

echo "---"

# ============================================
# MEMORY DETAILS DROPDOWN
# ============================================

echo "🧠 MEMORY USAGE"
echo "Memory Usage: ${MEM_PERCENT}%"
printf "App Memory: %.2f GB / %.0f GB\n" "$USED_MEM" "$TOTAL_MEM"
printf "Available: %.2f GB\n" "$FREE_MEM"
echo ""
echo "Top Memory Processes:"
top -l 1 -n 5 -o mem -stats pid,command,mem | tail -n +12 | head -n 5
