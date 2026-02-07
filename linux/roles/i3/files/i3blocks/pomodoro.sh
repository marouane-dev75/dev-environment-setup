#!/bin/bash
# Simple Pomodoro script for i3blocks with sound notifications
POMODORO_DURATION=25
SHORT_BREAK=5
LONG_BREAK=15
POMODORO_COUNT=0
MAX_POMODORO=4
# Sound file paths - try different options based on what's available
POMODORO_SOUND="$HOME/.config/i3blocks/sounds/pomodoro-end.mp3"
BREAK_SOUND="$HOME/.config/i3blocks/sounds/break-end.mp3"
WORK_FILE="/tmp/pomodoro_work"
BREAK_FILE="/tmp/pomodoro_break"
COUNT_FILE="/tmp/pomodoro_count"

# Function to play sound
play_sound() {
    if [ "$1" = "BEEP" ]; then
        # Use terminal bell if no sound files
        echo -e "\a"
    else
        # Try mpv first, then fall back to other players
        if command -v mpv &> /dev/null; then
            mpv "$1" --volume=70 --really-quiet &
        elif command -v paplay &> /dev/null; then
            paplay "$1" &
        elif command -v aplay &> /dev/null; then
            aplay "$1" &
        else
            # Last resort - terminal bell
            echo -e "\a"
        fi
    fi
}

# Function to reset the Pomodoro
reset_pomodoro() {
    echo "0" > "$WORK_FILE"
    echo "0" > "$BREAK_FILE"
    echo "0" > "$COUNT_FILE"
}

# Initialize if files don't exist
if [ ! -f "$WORK_FILE" ] && [ ! -f "$BREAK_FILE" ]; then
    reset_pomodoro
fi

case $BLOCK_BUTTON in
    1) # Left click to start/stop
        if [ -f "$WORK_FILE" ] && [ "$(cat "$WORK_FILE")" -eq "1" ]; then
            echo "0" > "$WORK_FILE"
            echo "0" > "$BREAK_FILE"
        else
            echo "1" > "$WORK_FILE"
            echo "0" > "$BREAK_FILE"
            START_TIME=$(date +%s)
            echo "$START_TIME" > "/tmp/pomodoro_start"
        fi
        ;;
    3) # Right click to reset
        reset_pomodoro
        ;;
esac

# Check if we're working
if [ "$(cat "$WORK_FILE")" -eq "1" ]; then
    START_TIME=$(cat "/tmp/pomodoro_start")
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
        echo "$START_TIME" > "/tmp/pomodoro_start"
        # Play sound and show notification
        play_sound "$POMODORO_SOUND"
        notify-send "Pomodoro finished!" "Take a break!"
    else
        MIN=$((REMAINING / 60))
        SEC=$((REMAINING % 60))
        echo "⏱️ $MIN:$(printf "%02d" $SEC) | $(cat "$COUNT_FILE")/$MAX_POMODORO"
    fi
# Check if we're on break
elif [ "$(cat "$BREAK_FILE")" -eq "1" ]; then
    START_TIME=$(cat "/tmp/pomodoro_start")
    CURRENT_TIME=$(date +%s)
    ELAPSED=$((CURRENT_TIME - START_TIME))
    
    # Determine if this is a long break or short break
    CURRENT_COUNT=$(cat "$COUNT_FILE")
    if [ "$CURRENT_COUNT" -ge "$MAX_POMODORO" ]; then
        BREAK_DURATION=$LONG_BREAK
    else
        BREAK_DURATION=$SHORT_BREAK
    fi
    
    REMAINING=$((BREAK_DURATION * 60 - ELAPSED))
    if [ "$REMAINING" -le "0" ]; then
        # Break finished
        echo "0" > "$BREAK_FILE"
        # Play sound and show notification
        play_sound "$BREAK_SOUND"
        
        # Reset count after a long break (when we've reached MAX_POMODORO)
        if [ "$CURRENT_COUNT" -ge "$MAX_POMODORO" ]; then
            reset_pomodoro
            notify-send "Long break finished!" "Starting a new Pomodoro set!"
        else
            notify-send "Break finished!" "Ready to work?"
        fi
    else
        MIN=$((REMAINING / 60))
        SEC=$((REMAINING % 60))
        echo "☕ $MIN:$(printf "%02d" $SEC) | $(cat "$COUNT_FILE")/$MAX_POMODORO"
    fi
else
    echo "🎯 Start | $(cat "$COUNT_FILE")/$MAX_POMODORO"
fi
