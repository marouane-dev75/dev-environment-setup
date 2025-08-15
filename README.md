# Development Environment Setup

This Ansible project automates the installation of essential development tools on a fresh Debian or Ubuntu installation.

## Tools Installed

### Core Development Tools
- **git** - Version control system
- **curl** - Command line tool for transferring data
- **wget** - Network downloader
- **vim** - Text editor with custom configuration
- **tmux** - Terminal multiplexer with custom configuration
- **zsh** - Z shell with oh-my-zsh configuration (set as default shell)
- **pnpm** - Fast, disk space efficient package manager (installed via nvm with Node.js LTS)

### Window Manager & Desktop Environment
- **i3** - Tiling window manager with comprehensive configuration
  - i3status, i3blocks, i3lock, dmenu, rofi, scrot
  - Custom i3blocks configuration with advanced status bar
  - Pomodoro timer with sound notifications
  - GPU usage monitoring
  - IP/VPN status checking
  - Custom scripts and sound files

### Snap Applications
- **VSCode** - Code editor (installed via snap)
- **Inkscape** - Vector graphics editor
- **GIMP** - Image manipulation program

### System Utilities
- **pulseaudio-utils** - Audio system utilities
- **bat** - Enhanced cat command with syntax highlighting
- **tig** - Text-mode interface for git
- **nautilus** - File manager
- **vlc** - Media player
- **net-tools** - Network utilities
- **openssh-server** - SSH server
- **ffmpeg** - Multimedia framework
- **maim** - Screenshot utility

### Fonts
- **Poppins** - Modern sans-serif font family
- **Roboto** - Google's signature font family

## Prerequisites

- Fresh Debian or Ubuntu installation
- User with sudo privileges
- Ansible installed on the system

## Project Structure

```
dev-environment-setup/
├── ansible.cfg          # Ansible configuration
├── inventory.yml        # Localhost inventory
├── site.yml            # Main playbook
├── README.md           # This file
└── roles/
    ├── common-tools/
    │   ├── tasks/main.yml
    │   └── handlers/main.yml
    ├── snap-apps/
    │   ├── tasks/main.yml
    │   └── handlers/main.yml
    ├── vim/
    │   ├── tasks/main.yml
    │   ├── handlers/main.yml
    │   └── files/vimrc
    ├── tmux/
    │   ├── tasks/main.yml
    │   ├── handlers/main.yml
    │   └── files/tmux.conf
    ├── zsh/
    │   ├── tasks/main.yml
    │   ├── handlers/main.yml
    │   └── files/zshrc
    ├── i3/
    │   ├── tasks/main.yml
    │   ├── handlers/main.yml
    │   └── files/
    │       ├── i3/config
    │       └── i3blocks/
    │           ├── config
    │           ├── gpu_usage.sh
    │           ├── ip_vpn_check.sh
    │           ├── pomodoro.sh
    │           └── sounds/
    │               ├── break-end.mp3
    │               ├── break-end.oga
    │               ├── pomodoro-end.mp3
    │               └── pomodoro-end.oga
    ├── pnpm/
    │   ├── tasks/main.yml
    │   └── handlers/main.yml
    └── fonts/
        ├── tasks/main.yml
        ├── handlers/main.yml
        ├── README.md
        └── files/
            ├── Poppins/
            └── Roboto/
```

## Usage

1. Clone or download this project to your system
2. Navigate to the project directory
3. Run the playbook:

```bash
ansible-playbook site.yml --ask-become-pass
```

You will be prompted for your sudo password.

## Features

- **Modular Design**: Each tool is installed via a separate Ansible role
- **No Global Variables**: Each role is self-contained
- **OS Detection**: Automatically detects Debian/Ubuntu systems
- **Verification**: Each installation is verified and version information is displayed
- **Configuration Management**: Deploys custom configurations with backup support
- **Idempotent**: Safe to run multiple times - will only make changes when necessary
- **Tagging System**: Install only the components you need
- **NVM Integration**: Node.js and pnpm are installed via nvm for better version management
- **Multi-Shell Support**: nvm is automatically added to both ~/.bashrc and ~/.zshrc
- **Oh-My-Zsh**: Automatically installs oh-my-zsh for enhanced zsh experience
- **Advanced i3 Setup**: Complete i3 configuration with productivity features
- **Font Management**: Automatic installation of popular font families
- **Snap Integration**: Modern application installation via snap packages

## Installation Order

The roles are executed in this order to ensure proper dependencies:
1. **common-tools** - Essential development utilities
2. **snap-apps** - Snap package manager and applications
3. **vim** - Text editor with configuration
4. **tmux** - Terminal multiplexer with configuration
5. **zsh** - Shell installation and configuration
6. **i3** - Window manager with advanced configuration
7. **pnpm** - Node.js and package manager (after shell setup)
8. **fonts** - System font installation

## Advanced i3 Configuration

The i3 window manager setup includes:

### i3blocks Status Bar Features
- **System Monitoring**: CPU, memory, disk usage
- **Network Status**: IP address and VPN connection status
- **Audio Controls**: Volume level and mute status
- **Date/Time Display**: Customizable format
- **Pomodoro Timer**: Built-in productivity timer with notifications

### Custom Scripts
- **GPU Usage Monitor**: Real-time GPU utilization display
- **IP/VPN Checker**: Shows current IP and VPN status
- **Pomodoro Timer**: 25-minute work sessions with 5-minute breaks
- **Sound Notifications**: Audio alerts for timer events

### Key Features
- **Backup System**: Existing configurations are backed up before deployment
- **Checksum Verification**: Only updates configurations when changes are detected
- **Custom Keybindings**: Optimized for development workflow
- **Multi-Monitor Support**: Proper workspace distribution

## Notes

- **i3 Window Manager**: Requires X11. After installation, use `startx i3` or configure your display manager to offer i3 as a session option
- **zsh**: Will be set as the default shell. You may need to log out and back in for the change to take effect
- **pnpm/Node.js**: Installed in user space via nvm. Shell configurations are automatically updated for both bash and zsh
- **oh-my-zsh**: Installed automatically with zsh for better user experience
- **Snap Applications**: Require snapd service to be running (automatically configured)
- **Fonts**: Installed system-wide in `/usr/share/fonts/truetype/`
- **i3blocks Scripts**: Executable scripts deployed to `~/.config/i3blocks/`
- **Sound Files**: Notification sounds for pomodoro timer in `~/.config/i3blocks/sounds/`

## Troubleshooting

If you encounter issues:

1. **General Issues**:
   - Ensure you have sudo privileges
   - Check that your system is Debian or Ubuntu based
   - Verify internet connectivity for downloading packages

2. **i3 Window Manager**:
   - Ensure you have a display server (X11) available
   - Check that all i3 dependencies are installed
   - Verify i3blocks scripts have execute permissions

3. **Shell Changes**:
   - Log out and back in, or restart your terminal
   - Check that zsh is set as default shell: `echo $SHELL`

4. **Snap Applications**:
   - Ensure snapd service is running: `systemctl status snapd`
   - Check snap installation: `snap version`

5. **Font Issues**:
   - Refresh font cache manually: `fc-cache -fv`
   - Verify fonts are installed: `fc-list | grep -i poppins`

## Customization

### Adding New Tools
1. Create a new role directory under `roles/`
2. Add `tasks/main.yml` and `handlers/main.yml` files
3. Update `site.yml` to include the new role with appropriate tags
4. Follow the existing patterns for OS detection and verification

### Adding New Fonts
1. Create a new directory under `roles/fonts/files/`
2. Add your font files to the directory
3. Run the playbook - fonts will be automatically detected and installed

### Customizing i3 Configuration
1. Modify `roles/i3/files/i3/config` for window manager settings
2. Edit `roles/i3/files/i3blocks/config` for status bar configuration
3. Add custom scripts to `roles/i3/files/i3blocks/` directory
4. Update sound files in `roles/i3/files/i3blocks/sounds/`

## Shell Configuration

The playbook automatically configures both bash and zsh environments:
- NVM is added to both `~/.bashrc` and `~/.zshrc` (if zsh is available)
- oh-my-zsh is installed for enhanced zsh experience
- zsh is set as the default shell
- Custom configurations are deployed for vim, tmux, and zsh

After installation, you can use node, pnpm, and all installed tools in any shell session.
