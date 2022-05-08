#!/bin/bash
install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

edit_bashrc() {
  if ! grep -qxF 'export SSH_AUTH_SOCK="$HOME/.ssh/agent-$WSL_DISTRO_NAME.sock"' "$HOME/.bashrc"; then
    cat >> "$HOME/.bashrc" <<'EOF'

# Use ssh-agent through wsl-ssh-agent
export SSH_AUTH_SOCK="$HOME/.ssh/agent-$WSL_DISTRO_NAME.sock"
if ! ss -a | grep -q "$SSH_AUTH_SOCK"; then
    rm -f "$SSH_AUTH_SOCK"
    ( setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"/mnt/c/wsl-ssh-agent/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork & ) >/dev/null 2>&1
fi
EOF
  fi
}

install_deb_packages socat
edit_bashrc
