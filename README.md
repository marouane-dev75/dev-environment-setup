# Development Environment Setup

An Ansible-powered toolkit that transforms your fresh Linux installation into a fully-featured, productivity-optimized development workstation.

## ✨ Key Features

### 🚀 Productivity-First Development Environment
- **Tiling Window Manager**: i3 with custom productivity enhancements including Pomodoro timer, GPU monitoring, and VPN status indicators
- **Terminal Mastery**: tmux multiplexer with custom configuration for efficient terminal workflows
- **Modern Shell Experience**: Zsh with oh-my-zsh, set as default shell for enhanced command-line productivity

### 🛠️ Comprehensive Development Toolkit
- **Code Editing**: Vim with custom configuration and VSCode via snap for flexible editing workflows
- **Package Management**: pnpm with Node.js LTS via nvm for efficient JavaScript/TypeScript development
- **System Utilities**: Essential tools like curl, wget, bat (enhanced cat), and ffmpeg for multimedia processing

### 🎨 Creative & Design Tools
- **Graphics Suite**: Inkscape and GIMP via snap for vector graphics and image manipulation
- **Media Processing**: VLC media player and ffmpeg for comprehensive multimedia handling
- **Screenshot Capabilities**: Maim utility for quick screen captures

### 🔧 System Optimization
- **Font Collection**: Poppins and Roboto font families for modern, readable interfaces
- **Audio Management**: PulseAudio utilities for system audio control
- **Network Tools**: Complete networking suite with SSH server and monitoring capabilities

### ⚙️ Advanced i3 Configuration
- **Smart Status Bar**: i3blocks with real-time system monitoring (CPU, memory, disk, network)
- **Productivity Timer**: Built-in Pomodoro technique implementation with audio notifications
- **GPU Monitoring**: Real-time graphics card utilization tracking
- **VPN Awareness**: Automatic IP and VPN connection status display
- **Custom Scripts**: Modular status bar components for personalized workflows

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/marouane-dev75/dev-environment-setup.git
cd dev-environment-setup

# Run the full setup
ansible-playbook site.yml --ask-become-pass

# Or run only specific components using tags
# Install only terminal tools (tmux, zsh)
ansible-playbook site.yml --tags "terminal" --ask-become-pass

# Install only development tools (vim, pnpm)
ansible-playbook site.yml --tags "tools" --ask-become-pass

# Install only window manager (i3)
ansible-playbook site.yml --tags "wm" --ask-become-pass
```

That's it! Your system will be transformed into a fully-configured development environment.

## 📋 Prerequisites

- Fresh Debian or Ubuntu installation
- User account with sudo privileges
- Ansible installed (`sudo apt install ansible`)
- Internet connection for package downloads

## 🏗️ Architecture

This project uses Ansible's modular role-based architecture for maintainable, scalable automation:

```
dev-environment-setup/
├── ansible.cfg          # Ansible configuration
├── inventory.yml        # Localhost inventory
├── site.yml            # Main playbook orchestrating all roles
└── roles/
    ├── common-tools/   # Core development utilities
    ├── snap-apps/      # Modern application distribution
    ├── vim/           # Text editor configuration
    ├── tmux/          # Terminal multiplexer setup
    ├── zsh/           # Shell environment enhancement
    ├── i3/            # Window manager & productivity tools
    ├── pnpm/          # JavaScript ecosystem
    └── fonts/         # Typography optimization
```

### Installation Strategy
- **Idempotent Execution**: Safe to run multiple times - only applies necessary changes
- **Dependency Management**: Roles execute in optimized order for proper dependency resolution
- **Configuration Backup**: Existing files are preserved before replacement
- **Verification**: Each component installation is validated with version checks
- **Tagging System**: Install only specific components when needed

## 🎯 What Makes This Special

### Intelligent Automation
- **OS Detection**: Automatically adapts to Debian/Ubuntu variants
- **Selective Installation**: Use Ansible tags to install only what you need
- **Configuration Management**: Deploys optimized configs with backup protection
- **Multi-Shell Support**: NVM integration works across bash and zsh environments

### Productivity Enhancements
- **Workflow Optimization**: Pre-configured tools work together seamlessly
- **Sound Design**: Audio notifications for productivity timers
- **Visual Consistency**: Curated font selection for better readability
- **Performance Monitoring**: Real-time system metrics in your status bar

### Developer Experience
- **Zero-Config Setup**: Start developing immediately after installation
- **Modern Tooling**: Latest versions of essential development tools
- **Extensible Design**: Easy to add new tools and configurations
- **Documentation**: Comprehensive guides for customization and troubleshooting

## 🔧 Customization

### Adding New Tools
```bash
# Create new role structure
mkdir -p roles/new-tool/{tasks,handlers,files}

# Add your installation logic
# Follow existing patterns for OS detection and verification
```

### Modifying i3 Configuration
- Edit `roles/i3/files/i3/config` for window management settings
- Customize `roles/i3/files/i3blocks/config` for status bar layout
- Add scripts to `roles/i3/files/i3blocks/` for custom functionality

### Font Management
- Add font files to `roles/fonts/files/new-font-family/`
- Re-run playbook to automatically install new fonts system-wide

## 🐛 Troubleshooting

### Common Issues
- **Permission Denied**: Ensure you're running with `--ask-become-pass`
- **i3 Won't Start**: Verify X11 is available with `startx i3`
- **Shell Not Changed**: Log out/in or restart terminal after zsh installation
- **Snap Apps Missing**: Check `systemctl status snapd` and `snap version`

### Verification Commands
```bash
# Check shell
echo $SHELL

# Verify Node.js/pnpm
node --version && pnpm --version

# Test i3 components
i3 --version && i3blocks --version

# Font installation
fc-list | grep -i poppins
```

## 📚 Advanced Usage

### Selective Installation
```bash
# Install only specific components
ansible-playbook site.yml --tags "vim,tmux" --ask-become-pass

# Skip certain roles
ansible-playbook site.yml --skip-tags "snap-apps" --ask-become-pass
```

### Development Workflow
1. **Terminal**: tmux for session management
2. **Editor**: Vim for quick edits, VSCode for complex projects
3. **Package Management**: pnpm for JavaScript dependencies
4. **Version Control**: Git with tig for repository operations
5. **Productivity**: i3 with Pomodoro timer for focused work sessions

This setup creates an environment where modern development practices are not just supported, but actively enhanced through thoughtful configuration and automation.
