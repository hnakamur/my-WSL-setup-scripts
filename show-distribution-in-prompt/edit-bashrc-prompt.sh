#!/bin/bash
if ! grep -qxF '    PS1='\''${debian_chroot:+($debian_chroot)}\u@$WSL_DISTRO_NAME@\h:\w\$ '\' "$HOME/.bashrc"; then
    sed -i -e '/^    PS1=/s/@\\h/@$WSL_DISTRO_NAME&/' "$HOME/.bashrc"
fi
