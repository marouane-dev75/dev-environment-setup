# Development Environment Setup

Automated development environment setup for **Linux (Debian/Ubuntu)** and **macOS** using Ansible.

## 🚀 Quick Start

### Prerequisites

**Linux (Debian/Ubuntu):**
```bash
sudo apt update
sudo apt install ansible git
```

**macOS:**
```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Ansible
brew install ansible
```

### Installation

```bash
# Clone the repository
git clone https://github.com/marouane-dev75/dev-environment-setup.git
cd dev-environment-setup

# Run the setup (automatically detects your OS)
ansible-playbook site.yml --ask-become-pass
```

## 📋 What Gets Installed

### Linux (Debian/Ubuntu)
- **Development Tools**: curl, wget, git, vim, htop, ffmpeg, and more
- **Terminal**: tmux, zsh with oh-my-zsh
- **Window Manager**: i3 with custom productivity features (Pomodoro timer, GPU monitoring, VPN status)
- **GUI Apps**: VSCode, Inkscape, GIMP (via snap)
- **Package Manager**: pnpm for Node.js development
- **Fonts**: Poppins and Roboto font families

### macOS
- **Package Manager**: Homebrew
- **Terminal**: zsh with oh-my-zsh, tmux, vim
- **Window Manager**: AeroSpace (tiling window manager)
- **Status Bar**: SwiftBar with custom plugins (Pomodoro timer, CPU/Memory/Network monitoring)
- **GUI Apps**: Various productivity and development tools
- **Development Tools**: Common CLI tools (curl, wget, git, etc.)

## 🎯 Platform-Specific Usage

### Run Linux Setup Only
```bash
ansible-playbook linux/site.yml --ask-become-pass
```

### Run macOS Setup Only
```bash
ansible-playbook macos/site.yml --ask-become-pass
```

### Install Specific Components (Tags)

**Linux:**
```bash
# Install only terminal tools (tmux, zsh)
ansible-playbook linux/site.yml --tags "terminal" --ask-become-pass

# Install only development tools (vim, pnpm)
ansible-playbook linux/site.yml --tags "tools" --ask-become-pass

# Install only window manager (i3)
ansible-playbook linux/site.yml --tags "wm" --ask-become-pass
```

**macOS:**
```bash
# Install only zsh
ansible-playbook macos/site.yml --tags "zsh" --ask-become-pass

# Install only Homebrew
ansible-playbook macos/site.yml --tags "homebrew" --ask-become-pass

# Install only status bar monitoring
ansible-playbook macos/site.yml --tags "status-bar" --ask-become-pass
```

## 🏗️ Project Structure

```
dev-environment-setup/
├── site.yml              # Main playbook (auto-detects OS)
├── linux/
│   ├── site.yml         # Linux-specific playbook
│   └── roles/           # Linux roles (i3, snap-apps, etc.)
└── macos/
    ├── site.yml         # macOS-specific playbook
    └── roles/           # macOS roles (homebrew, zsh)
```

## 🔧 Customization

### Linux
- **i3 Config**: Edit `linux/roles/i3/files/i3/config`
- **i3blocks**: Customize `linux/roles/i3/files/i3blocks/config`
- **Vim**: Modify `linux/roles/vim/files/vimrc`
- **Tmux**: Edit `linux/roles/tmux/files/tmux.conf`
- **Zsh**: Update `linux/roles/zsh/files/zshrc`

### macOS
- **Zsh**: Edit `macos/roles/zsh/files/zshrc`

## 🐛 Troubleshooting

### Linux
- **Permission Denied**: Ensure you're running with `--ask-become-pass`
- **i3 Won't Start**: Verify X11 is available with `startx i3`
- **Shell Not Changed**: Log out/in or restart terminal after zsh installation

### macOS
- **Homebrew Not Found**: Ensure Homebrew is in your PATH. Restart terminal or run:
  ```bash
  eval "$(/opt/homebrew/bin/brew shellenv)"  # Apple Silicon
  eval "$(/usr/local/bin/brew shellenv)"     # Intel
  ```
- **Ansible Not Found**: Install Ansible via Homebrew: `brew install ansible`

## 📚 Available Tags

### Linux
- `common-tools`, `tools` - Core development utilities
- `snapd` - Snap package manager and apps
- `vim` - Vim editor
- `tmux`, `terminal` - Terminal multiplexer
- `zsh`, `terminal` - Zsh shell
- `i3`, `wm` - i3 window manager
- `pnpm`, `nodejs` - Node.js package manager
- `fonts`, `system` - Font installation

### macOS
- `homebrew`, `setup` - Homebrew package manager
- `zsh`, `terminal` - Zsh shell
- `status-bar` - SwiftBar status bar monitoring
- `tmux`, `terminal` - Terminal multiplexer
- `vim` - Vim editor
- `aerospace` - AeroSpace window manager
- `gui-apps` - GUI applications
- `common-tools`, `tools` - Common development tools

## 🎯 Roadmap

### Planned macOS Features
- [ ] Common development tools (git, curl, wget, vim, etc.)
- [ ] tmux configuration
- [ ] pnpm and Node.js setup
- [ ] GUI applications via Homebrew Cask (VSCode, etc.)
- [ ] Font installation
- [ ] Optional window manager (Yabai/Rectangle)

## 📝 License

MIT License - Feel free to use and modify as needed.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
