# Fonts Role

This Ansible role manages system fonts by copying font directories from the role's `files/` directory to `/usr/share/fonts/truetype/`.

## Usage

1. Add your font directories to `roles/fonts/files/`
2. Each font family should be in its own directory (e.g., `Poppins/`, `Roboto/`)
3. Run the playbook with the fonts role

## Features

- **Idempotent**: Only copies fonts that don't already exist in the system
- **Dynamic**: Automatically detects all font directories in the `files/` folder
- **Efficient**: Only refreshes font cache (`fc-cache -fv`) when new fonts are installed
- **Secure**: Uses proper permissions (755 for directories, 644 for files)

## Example Structure

```
roles/fonts/files/
├── Poppins/
│   ├── OFL.txt
│   ├── Poppins-Regular.ttf
│   ├── Poppins-Bold.ttf
│   └── ...
└── Roboto/
    ├── OFL.txt
    ├── Roboto-Regular.ttf
    └── ...
```

## Tags

- `fonts`: Run only the fonts role
- `system`: Run system-related roles including fonts
