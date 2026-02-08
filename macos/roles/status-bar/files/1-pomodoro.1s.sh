#!/bin/bash
# SwiftBar Pomodoro Timer
# <swiftbar.refreshOnOpen>true</swiftbar.refreshOnOpen>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>

# Pomodoro settings
POMODORO_DURATION=25
SHORT_BREAK=5
LONG_BREAK=15
POMODORO_COUNT=0
MAX_POMODORO=4

# Sound file paths
POMODORO_SOUND="$HOME/swiftbar/sounds/pomodoro-end.mp3"
BREAK_SOUND="$HOME/swiftbar/sounds/break-end.mp3"

# State files
WORK_FILE="/tmp/pomodoro_work"
BREAK_FILE="/tmp/pomodoro_break"
COUNT_FILE="/tmp/pomodoro_count"
START_FILE="/tmp/pomodoro_start"

# Function to play sound
play_sound() {
    if [ -f "$1" ]; then
        afplay "$1" &
    else
        # Fallback to system sound
        afplay /System/Library/Sounds/Glass.aiff &
    fi
}

# Function to send notification
send_notification() {
    osascript -e "display notification \"$2\" with title \"Pomodoro Timer\" subtitle \"$1\""
}

# Function to reset the Pomodoro
reset_pomodoro() {
    echo "0" > "$WORK_FILE"
    echo "0" > "$BREAK_FILE"
    echo "0" > "$COUNT_FILE"
    rm -f "$START_FILE"
}

# Initialize if files don't exist
if [ ! -f "$WORK_FILE" ] && [ ! -f "$BREAK_FILE" ]; then
    reset_pomodoro
fi

# Handle SwiftBar parameters (menu item clicks)
if [ "$1" = "start" ]; then
    if [ "$(cat "$WORK_FILE")" -eq "1" ]; then
        # Stop if already running
        echo "0" > "$WORK_FILE"
        echo "0" > "$BREAK_FILE"
        rm -f "$START_FILE"
    else
        # Start new Pomodoro
        echo "1" > "$WORK_FILE"
        echo "0" > "$BREAK_FILE"
        START_TIME=$(date +%s)
        echo "$START_TIME" > "$START_FILE"
    fi
    exit 0
elif [ "$1" = "reset" ]; then
    reset_pomodoro
    exit 0
fi

# Check if we're working
if [ "$(cat "$WORK_FILE")" -eq "1" ]; then
    START_TIME=$(cat "$START_FILE")
    CURRENT_TIME=$(date +%s)
    ELAPSED=$((CURRENT_TIME - START_TIME))
    REMAINING=$((POMODORO_DURATION * 60 - ELAPSED))
    
    if [ "$REMAINING" -le "0" ]; then
        # Pomodoro finished
        echo "0" > "$WORK_FILE"
        echo "1" > "$BREAK_FILE"
        POMODORO_COUNT=$(($(cat "$COUNT_FILE") + 1))
        echo "$POMODORO_COUNT" > "$COUNT_FILE"
        START_TIME=$(date +%s)
        echo "$START_TIME" > "$START_FILE"
        
        # Play sound and show notification
        play_sound "$POMODORO_SOUND"
        send_notification "Work Session Complete!" "Time for a break! 🎉"
        
        MIN=0
        SEC=0
    else
        MIN=$((REMAINING / 60))
        SEC=$((REMAINING % 60))
    fi
    
    CURRENT_COUNT=$(cat "$COUNT_FILE")
    echo "⏱️ $MIN:$(printf "%02d" $SEC) | bash='$0' param1=start terminal=false refresh=true"
    echo "---"
    echo "⏸️  Pause | bash='$0' param1=start terminal=false refresh=true"
    echo "Working: $(cat "$COUNT_FILE")/$MAX_POMODORO"
    echo "🔄 Reset | bash='$0' param1=reset terminal=false refresh=true"

# Check if we're on break
elif [ "$(cat "$BREAK_FILE")" -eq "1" ]; then
    START_TIME=$(cat "$START_FILE")
    CURRENT_TIME=$(date +%s)
    ELAPSED=$((CURRENT_TIME - START_TIME))
    
    # Determine if this is a long break or short break
    CURRENT_COUNT=$(cat "$COUNT_FILE")
    if [ "$CURRENT_COUNT" -ge "$MAX_POMODORO" ]; then
        BREAK_DURATION=$LONG_BREAK
        BREAK_TYPE="Long Break"
    else
        BREAK_DURATION=$SHORT_BREAK
        BREAK_TYPE="Short Break"
    fi
    
    REMAINING=$((BREAK_DURATION * 60 - ELAPSED))
    
    if [ "$REMAINING" -le "0" ]; then
        # Break finished
        echo "0" > "$BREAK_FILE"
        
        # Play sound and show notification
        play_sound "$BREAK_SOUND"
        
        # Reset count after a long break
        if [ "$CURRENT_COUNT" -ge "$MAX_POMODORO" ]; then
            reset_pomodoro
            send_notification "Long Break Complete!" "Starting a new Pomodoro set! 🚀"
        else
            send_notification "Break Complete!" "Ready to work? 💪"
        fi
        
        MIN=0
        SEC=0
    else
        MIN=$((REMAINING / 60))
        SEC=$((REMAINING % 60))
    fi
    
    echo "☕ $MIN:$(printf "%02d" $SEC) | bash='$0' param1=start terminal=false refresh=true"
    echo "---"
    echo "⏭️  Skip Break | bash='$0' param1=start terminal=false refresh=true"
    echo "$BREAK_TYPE: $(cat "$COUNT_FILE")/$MAX_POMODORO"
    echo "🔄 Reset | bash='$0' param1=reset terminal=false refresh=true"

else
    # Idle state
    echo "🎯 Start | bash='$0' param1=start terminal=false refresh=true"
    echo "---"
    echo "▶️  Start Pomodoro | bash='$0' param1=start terminal=false refresh=true"
    echo "Pomodoros: $(cat "$COUNT_FILE")/$MAX_POMODORO"
    echo "🔄 Reset | bash='$0' param1=reset terminal=false refresh=true"
fi
