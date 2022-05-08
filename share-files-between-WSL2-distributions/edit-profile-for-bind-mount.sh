#!/bin/bash
if ! grep -qxF '    wsl.exe -d "$WSL_DISTRO_NAME" -u root mount --bind / "/mnt/wsl/$WSL_DISTRO_NAME/"' "$HOME/.profile"; then
    cat >> "$HOME/.profile" <<'EOF'

# bind mount root directory for sharing files between WSL distributions
if [ ! -d "/mnt/wsl/$WSL_DISTRO_NAME" ]; then
    mkdir -p "/mnt/wsl/$WSL_DISTRO_NAME"
    wsl.exe -d "$WSL_DISTRO_NAME" -u root mount --bind / "/mnt/wsl/$WSL_DISTRO_NAME/"
fi
EOF
fi
