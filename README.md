# Development Environment Setup

This Ansible project automates the installation of essential development tools on a fresh Debian or Ubuntu installation.

## Tools Installed

- **vim** - Text editor
- **tmux** - Terminal multiplexer
- **i3** - Tiling window manager (with dependencies: i3status, i3lock, dmenu, xorg)
- **zsh** - Z shell with oh-my-zsh configuration (set as default shell)
- **pnpm** - Fast, disk space efficient package manager (installed via nvm with Node.js LTS)

## Prerequisites

- Fresh Debian or Ubuntu installation
- User with sudo privileges
- Ansible installed on the system

## Project Structure

```
envirement_setup/
├── ansible.cfg          # Ansible configuration
├── inventory.yml        # Localhost inventory
├── site.yml            # Main playbook
├── README.md           # This file
└── roles/
    ├── vim/
    │   ├── tasks/main.yml
    │   └── handlers/main.yml
    ├── tmux/
    │   ├── tasks/main.yml
    │   └── handlers/main.yml
    ├── i3/
    │   ├── tasks/main.yml
    │   └── handlers/main.yml
    ├── zsh/
    │   ├── tasks/main.yml
    │   └── handlers/main.yml
    └── pnpm/
        ├── tasks/main.yml
        └── handlers/main.yml
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
- **NVM Integration**: Node.js and pnpm are installed via nvm for better version management
- **Multi-Shell Support**: nvm is automatically added to both ~/.bashrc and ~/.zshrc
- **Oh-My-Zsh**: Automatically installs oh-my-zsh for enhanced zsh experience

## Installation Order

The roles are executed in this order to ensure proper dependencies:
1. **vim** - Basic text editor
2. **tmux** - Terminal multiplexer
3. **i3** - Window manager
4. **zsh** - Shell installation and configuration
5. **pnpm** - Node.js and package manager (after shell setup)

## Notes

- **i3 Window Manager**: Requires X11. After installation, use `startx i3` or configure your display manager to offer i3 as a session option
- **zsh**: Will be set as the default shell. You may need to log out and back in for the change to take effect
- **pnpm/Node.js**: Installed in user space via nvm. Shell configurations are automatically updated for both bash and zsh
- **oh-my-zsh**: Installed automatically with zsh for better user experience
- **Idempotent**: Safe to run multiple times - will only make changes when necessary

## Troubleshooting

If you encounter issues:

1. Ensure you have sudo privileges
2. Check that your system is Debian or Ubuntu based
3. Verify internet connectivity for downloading packages
4. For i3: Ensure you have a display server (X11) available
5. For shell changes: Log out and back in, or restart your terminal

## Customization

To add more tools:
1. Create a new role directory under `roles/`
2. Add `tasks/main.yml` and `handlers/main.yml` files
3. Update `site.yml` to include the new role
4. Follow the existing patterns for OS detection and verification

## Shell Configuration

The playbook automatically configures both bash and zsh environments:
- NVM is added to both `~/.bashrc` and `~/.zshrc` (if zsh is available)
- oh-my-zsh is installed for enhanced zsh experience
- zsh is set as the default shell

After installation, you can use node and pnpm commands in any shell session.
