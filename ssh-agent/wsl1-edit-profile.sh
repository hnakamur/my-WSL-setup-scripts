#!/bin/bash
edit_profile() {
  if ! grep -qxF 'SSH_AUTH_SOCK=/mnt/c/wsl-ssh-agent/ssh-agent.sock' "$HOME/.profile"; then
    cat >> "$HOME/.profile" <<'EOF'

SSH_AUTH_SOCK=/mnt/c/wsl-ssh-agent/ssh-agent.sock
export SSH_AUTH_SOCK
EOF
  fi
}
edit_profile
