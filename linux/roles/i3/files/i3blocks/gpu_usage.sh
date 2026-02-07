#!/bin/bash

# GPU monitoring script for i3blocks
# Displays GPU utilization and VRAM usage using nvidia-smi
# If no GPU or nvidia-smi unavailable, displays nothing

# Check if nvidia-smi is available
if ! command -v nvidia-smi &> /dev/null; then
    exit 0  # Silent exit if nvidia-smi not found
fi

# Get GPU info, exit silently if no GPU or command fails
GPU_INFO=$(nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total --format=csv,noheader,nounits 2>/dev/null)
if [ $? -ne 0 ] || [ -z "$GPU_INFO" ]; then
    exit 0  # Silent exit if command fails or no output
fi

# Parse the output
GPU_UTIL=$(echo "$GPU_INFO" | awk -F', ' '{print $1}')
MEM_USED=$(echo "$GPU_INFO" | awk -F', ' '{print $2}')
MEM_TOTAL=$(echo "$GPU_INFO" | awk -F', ' '{print $3}')

# Check if we got valid numeric values
if ! [[ "$GPU_UTIL" =~ ^[0-9]+$ ]] || ! [[ "$MEM_USED" =~ ^[0-9]+$ ]] || ! [[ "$MEM_TOTAL" =~ ^[0-9]+$ ]]; then
    exit 0  # Silent exit if parsing failed
fi

# Calculate memory usage percentage
MEM_USAGE_PERCENT=$(( (MEM_USED * 100) / MEM_TOTAL ))

# Determine color based on usage thresholds
COLOR=""
if [ "$GPU_UTIL" -gt 90 ] || [ "$MEM_USAGE_PERCENT" -gt 80 ]; then
    COLOR="#ffbbb8"  # Red for high usage
elif [ "$GPU_UTIL" -gt 70 ] || [ "$MEM_USAGE_PERCENT" -gt 60 ]; then
    COLOR="#ffd587"  # Orange for medium usage
fi

# Convert MB to GB for better readability if total memory > 1024MB
if [ "$MEM_TOTAL" -gt 1024 ]; then
    # Use bc for floating point arithmetic if available, otherwise use awk
    if command -v bc &> /dev/null; then
        MEM_USED_GB=$(echo "scale=1; $MEM_USED/1024" | bc | sed 's/^\./0./')
        MEM_TOTAL_GB=$(echo "scale=1; $MEM_TOTAL/1024" | bc | sed 's/^\./0./')
    else
        MEM_USED_GB=$(awk "BEGIN {printf \"%0.1f\", $MEM_USED/1024}")
        MEM_TOTAL_GB=$(awk "BEGIN {printf \"%0.1f\", $MEM_TOTAL/1024}")
    fi
    OUTPUT="${GPU_UTIL}% ${MEM_USED_GB}GB"
else
    OUTPUT="${GPU_UTIL}% ${MEM_USED}MB"
fi

# Output with color if specified
if [ -n "$COLOR" ]; then
    echo "$OUTPUT"
    echo "$OUTPUT"
    echo "$COLOR"
else
    echo "$OUTPUT"
fi
