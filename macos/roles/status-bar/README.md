# Status Bar Monitoring for macOS

This Ansible role installs and configures comprehensive status bar monitoring for macOS using SwiftBar, providing system metrics and productivity tools similar to the Linux i3blocks implementation.

## Features

### 🎯 Pomodoro Timer
- **25-minute work sessions** with 5-minute short breaks and 15-minute long breaks
- **Tracks 4 Pomodoros** before triggering a long break
- **Sound notifications** using audio files
- **macOS native notifications** via AppleScript
- **Click controls**: Start/Pause, Skip breaks, Reset timer

### 💻 CPU Monitor
- Real-time CPU usage percentage
- Color-coded indicators (🟢 <30%, 🟡 30-70%, 🔴 >70%)
- Detailed CPU usage breakdown
- Top 5 CPU-consuming processes

### 🧠 Memory Monitor
- Real-time memory usage (Used/Total in GB)
- Color-coded indicators (🟢 <50%, 🟡 50-80%, 🔴 >80%)
- Detailed memory statistics (Free, Used, Total)
- Top 5 memory-consuming processes

### 🌐 Network/VPN Monitor
- Public IP address display
- VPN status detection (checks if outside France)
- Color-coded VPN status (🟢 Active, 🔴 Inactive)
- Location information (City, Country)
- ISP/Provider information
- Local IP address

## Requirements

- macOS
- Homebrew (installed via the homebrew role)
- Ansible

## Installation

This role is automatically included when running the macOS playbook:

```bash
ansible-playbook macos/site.yml
```

Or install just the status bar monitoring:

```bash
ansible-playbook macos/site.yml --tags status-bar
```

## Post-Installation Setup

After running the playbook:

1. **Open SwiftBar** from your Applications folder
2. **Set the plugin folder** when prompted to:
   ```
   ~/swiftbar/plugins
   ```
3. All monitoring plugins will appear in your menu bar

## Menu Bar Display

- **🎯 Start** - Pomodoro timer (idle state)
- **⏱️ MM:SS** - Active work session
- **☕ MM:SS** - Break time
- **🟢 CPU XX%** - CPU usage
- **🟢 MEM XX%** - Memory usage
- **🟢 VPN: XXX.XXX.XXX.XXX** - Network/VPN status

## Plugin Details

### Pomodoro Timer (`pomodoro.1s.sh`)
- **Refresh Rate**: 1 second
- **Controls**:
  - Click icon: Start/Pause/Skip
  - Dropdown menu: Full controls and status
- **Cycle**: 4 Pomodoros → Long break → Reset

### CPU Monitor (`cpu.5s.sh`)
- **Refresh Rate**: 5 seconds
- **Display**: Icon + percentage
- **Dropdown**: Detailed CPU info and top processes

### Memory Monitor (`memory.5s.sh`)
- **Refresh Rate**: 5 seconds
- **Display**: Icon + Used/Total memory
- **Dropdown**: Detailed memory stats and top processes

### Network/VPN Monitor (`network.60s.sh`)
- **Refresh Rate**: 60 seconds
- **Display**: VPN status + Public IP
- **Dropdown**: Full network information
- **VPN Detection**: Checks if country is not France

## File Structure

```
macos/roles/status-bar/
├── tasks/
│   └── main.yml                    # Installation tasks
├── files/
│   ├── pomodoro.1s.sh             # Pomodoro timer plugin
│   ├── cpu.5s.sh                  # CPU monitor plugin
│   ├── memory.5s.sh               # Memory monitor plugin
│   ├── network.60s.sh             # Network/VPN monitor plugin
│   └── sounds/
│       ├── pomodoro-end.mp3       # Work session complete sound
│       └── break-end.mp3          # Break complete sound
├── handlers/
│   └── main.yml                    # Handlers
└── README.md                       # This file
```

## Customization

### Pomodoro Timer
Edit `files/pomodoro.1s.sh`:
```bash
POMODORO_DURATION=25    # Work session in minutes
SHORT_BREAK=5           # Short break in minutes
LONG_BREAK=15           # Long break in minutes
MAX_POMODORO=4          # Number of Pomodoros before long break
```

### VPN Detection
Edit `files/network.60s.sh` to change the country check:
```bash
# Change "FR" to your home country code
if echo "$COUNTRY" | grep -q -i -v "FR"; then
```

### Refresh Rates
Rename files to change update frequency:
- `.1s.` = 1 second
- `.5s.` = 5 seconds
- `.30s.` = 30 seconds
- `.60s.` = 60 seconds
- `.5m.` = 5 minutes

## Comparison with Linux Version

| Feature | Linux (i3blocks) | macOS (SwiftBar) |
|---------|------------------|------------------|
| Display | i3blocks status bar | Menu bar |
| Pomodoro | ✅ | ✅ |
| CPU Monitor | ✅ | ✅ |
| Memory Monitor | ✅ | ✅ |
| Network/VPN | ✅ | ✅ |
| Notifications | notify-send | osascript |
| Sound | mpv/paplay | afplay |
| Controls | Mouse clicks | Menu clicks |

## Troubleshooting

### SwiftBar not showing plugins

1. Check if SwiftBar is running
2. Verify the plugin folder is set to `~/swiftbar/plugins`
3. Ensure scripts have execute permissions:
   ```bash
   chmod +x ~/swiftbar/plugins/*.sh
   ```

### No sound notifications (Pomodoro)

1. Check if sound files exist:
   ```bash
   ls -la ~/swiftbar/sounds/
   ```
2. Test sound playback:
   ```bash
   afplay ~/swiftbar/sounds/pomodoro-end.mp3
   ```

### Network plugin shows error

1. Check internet connection
2. Verify curl is working:
   ```bash
   curl -s https://ipinfo.io/
   ```

### High CPU usage from monitoring

1. Increase refresh intervals by renaming files:
   - `cpu.5s.sh` → `cpu.10s.sh` (10 seconds)
   - `memory.5s.sh` → `memory.10s.sh` (10 seconds)

### Memory calculations incorrect

The memory script uses `vm_stat` and may show different values than Activity Monitor due to how macOS manages memory (compressed, cached, etc.). This is normal.

## Advanced Usage

### Adding Custom Plugins

1. Create a new script in `files/` directory
2. Name it with refresh interval: `myplugin.Xs.sh`
3. Add SwiftBar headers:
   ```bash
   #!/bin/bash
   # <swiftbar.refreshOnOpen>true</swiftbar.refreshOnOpen>
   # <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
   ```
4. Output format:
   ```bash
   echo "Menu Bar Text"
   echo "---"
   echo "Dropdown Item 1"
   echo "Dropdown Item 2"
   ```
5. Add to `tasks/main.yml` loop

### SwiftBar Output Format

- First line: Menu bar display
- `---`: Separator for dropdown menu
- Subsequent lines: Dropdown menu items
- `| bash='script' param1=value`: Clickable actions

## License

Same as the parent dev-environment-setup repository.
