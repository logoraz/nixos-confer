# bashrc file

# Custom prompt with color
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# NixOS generalized rebuild function for flakes
nixos-flake() {
    local action=${1}          # No default - use must specify
    local host=${2:-framework} # Default to 'framework' if no argument
    sudo nixos-rebuild ${action} \
       --flake git+file:///home/logoraz/.config/nixos#${host}
}

# NixOS clean function - takes days as argument
nixos-clean() {
    sudo nix-collect-garbage --delete-older-than "${1:-30d}"
    sudo /run/current-system/bin/switch-to-configuration boot
}

# Wipe all old generations (keep only current)
nixos-wipe() {
    sudo nix profile wipe-history --profile /nix/var/nix/profiles/system
    sudo nix-collect-garbage
    sudo /run/current-system/bin/switch-to-configuration boot
}

# Search for NixOS packages
nixos-search() {
    nix search nixpkgs ${1}
}
