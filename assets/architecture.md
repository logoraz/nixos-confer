# NixOS Flake Architecture Plan



### Essential Commands

```bash
# Rebuild and apply changes immediately
nixos-flake            # Function: sudo nixos-rebuild switch --flake git+file:///home/logoraz/.config/nixos#framework

# Clean up old generations (time-based)
nixos-clean            # Function: sudo nix-collect-garbage --delete-older-than <days>
nixos-clean            # Default: 30 days
nixos-clean 7d         # Delete older than 7 days

# Dry run - preview what would change
nixos-dry              # Function: sudo nixos-rebuild dry-build --flake git+file://...

# List all system generations
nixos-list             # Alias: nixos-rebuild list-generations

# Rollback to previous generation
nixos-rollback         # Alias: sudo nixos-rebuild switch --rollback

# Update flake inputs (nixpkgs, home-manager)
nix-update             # Alias: nix flake update ~/.config/nixos

# Show flake outputs
nix-show               # Alias: nix flake show ~/.config/nixos

# Create temporary shell with packages (test without installing)
nix shell nixpkgs#<package-name>
# Example: nix shell nixpkgs#python3 nixpkgs#gcc nixpkgs#nodejs

# Or use the older nix-shell (also works)
nix-shell -p <package-name>

# Search for packages
nix search nixpkgs <package-name>
# Example: nix search nixpkgs firefox
```

**Note:** Functions are defined in `bashrc.sh`, aliases in `shell.nix`. Use the full
commands if not loaded yet.



## Current Flake Directory Structure

Your current setup follows a clean, well-organized structure located in `~/.config/nixos`:

```
~/.config/nixos/
├── flake.nix                           # Entry point - defines inputs and outputs
├── flake.lock                          # Lock file (auto-generated)
├── hosts/
│   └── framework/
│       ├── configuration.nix           # System-level configuration
│       └── hardware-configuration.nix  # Hardware-specific settings (auto-generated)
└── home/
    └── logoraz/
        ├── home.nix                    # Main user config (imports modules)
        └── modules/
            ├── shell.nix               # Bash/shell configuration (Nix)
            ├── bashrc.sh               # Bash functions (pure bash)
            ├── gnome.nix               # GNOME/dconf settings
            ├── emacs.nix               # Emacs-specific config
            └── terminal.nix            # Foot terminal configuration
```

**Current Status:** ✅ All configurations are declarative, modular, and git-tracked

## File Purposes

### Core Files

**`flake.nix`**
- Entry point for your NixOS configuration
- Defines inputs (nixpkgs, home-manager)
- Defines outputs (nixosConfigurations)
- Maps configuration files together

**`flake.lock`**
- Auto-generated lock file
- Pins exact versions of all inputs
- Ensures reproducible builds

### System Configuration

**`hosts/framework/configuration.nix`**
- System-wide settings (boot, networking, services)
- Desktop environment configuration
- System packages
- User account definitions

**`hosts/framework/hardware-configuration.nix`**
- Hardware-specific settings (auto-generated)
- Filesystems, boot loader
- Kernel modules

### User Configuration (Home Manager)

**`home/logoraz/home.nix`**
- Main entry point for user configuration
- Imports user modules
- Defines user packages
- Sets home manager state version

**`home/logoraz/modules/shell.nix`**
- Bash configuration (Nix part: aliases, environment variables)
- Loads bash functions from bashrc.sh
- History settings
- Future shell configs (zsh, fish)

**`home/logoraz/modules/bashrc.sh`**
- Pure bash functions (no Nix escaping)
- Custom prompt configuration
- NixOS rebuild/clean/dry functions
- Loaded via `builtins.readFile` in shell.nix

**`home/logoraz/modules/gnome.nix`**
- GNOME desktop user settings
- Dconf configurations (theme, extensions)
- GTK preferences

**`home/logoraz/modules/emacs.nix`**
- Emacs-specific configuration
- Desktop entry customization
- Future: packages, init files

**`home/logoraz/modules/terminal.nix`**
- Foot terminal emulator configuration
- Terminal appearance (fonts, colors, transparency)
- Server-side decorations for GNOME integration

## Future Modularization Roadmap

As your configuration grows, you'll want to modularize for better organization and
reusability:

### Phase 1: Current State ✅ (Modular Home Config)
```
~/.config/nixos/
├── flake.nix
├── flake.lock
├── hosts/
│   └── framework/
│       ├── configuration.nix
│       └── hardware-configuration.nix
└── home/
    └── logoraz/
        ├── home.nix                    # Imports user modules
        └── modules/                    # ✅ Already implemented
            ├── shell.nix               # Bash configuration (Nix)
            ├── bashrc.sh               # Bash functions (pure bash)
            ├── gnome.nix               # GNOME/dconf settings
            ├── emacs.nix               # Emacs config
            └── terminal.nix            # Foot terminal config
```

**You are here!** Your home configuration is modular with clean separation between Nix
and bash code.

### Phase 2: System Modularization (When You Add a Second Machine)

When you get a second machine or your system config grows beyond 150 lines:

```
~/.config/nixos/
├── flake.nix
├── flake.lock
├── hosts/
│   ├── framework/
│   │   ├── configuration.nix           # Imports from modules/
│   │   └── hardware-configuration.nix
│   └── desktop/                        # Future second machine
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── home/
│   └── logoraz/
│       ├── home.nix
│       └── modules/
│           ├── shell.nix
│           ├── bashrc.sh
│           ├── gnome.nix
│           ├── emacs.nix
│           └── terminal.nix
└── modules/                            # System-level modules
    ├── common.nix                      # Shared by all machines
    ├── desktop/
    │   ├── gnome.nix                   # GNOME system config
    │   └── fonts.nix                   # Font configuration
    └── services/
        ├── printing.nix
        └── flatpak.nix
```

### Phase 3: Advanced Expansion (When Needed)

For complex setups with multiple machines and custom packages:

```
~/.config/nixos/
├── flake.nix
├── flake.lock
├── hosts/                              # Machine-specific configs
│   ├── framework/
│   └── desktop/
├── home/                               # User configs (per machine if needed)
│   ├── logoraz/
│   └── otheruser/                      # Multi-user support
├── modules/                            # Reusable system modules
│   ├── common.nix
│   ├── desktop/
│   ├── services/
│   └── hardware/
├── overlays/                           # Package overlays/modifications
├── packages/                           # Custom package definitions
└── lib/                                # Helper functions
```

## When to Move to Next Phase

**Phase 1 (Current) ✅**
- Single machine with modular home config
- Config files under 150 lines each
- Easy to maintain and understand

**Move to Phase 2 when:**
- Adding a second machine (need shared system modules)
- `configuration.nix` exceeds 150-200 lines
- You're duplicating system settings
- Want to separate GNOME/desktop from base system

**Move to Phase 3 when:**
- Managing 3+ machines
- Creating custom packages
- Need package overlays
- Building complex multi-user setups
- Config files exceed 300+ lines

## Current Module Examples

### User Module: `home/logoraz/modules/shell.nix`

```nix
{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;

    shellAliases = {
      ll = "ls -lah";
      nixos-list = "nixos-rebuild list-generations";
      nixos-rollback = "sudo nixos-rebuild switch --rollback";
      nix-update = "nix flake update ~/.config/nixos";
    };

    sessionVariables = {
      LC_COLLATE = "C";
      EDITOR = "emacsclient -c";
      VISUAL = "emacsclient -c";
    };

    # Load bash functions from external file
    bashrcExtra = builtins.readFile ./bashrc.sh;

    historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
    historySize = 10000;
  };
}
```

### Bash Functions: `home/logoraz/modules/bashrc.sh`

```bash
# Custom prompt with color
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# NixOS rebuild function
nixos-flake() {
  sudo nixos-rebuild switch \
       --flake git+file:///home/logoraz/.config/nixos#framework
}

# NixOS clean function - takes days as argument
nixos-clean() {
  sudo nix-collect-garbage --delete-older-than "${1:-30d}"
}

# Dry run - see what would change
nixos-dry() {
  sudo nixos-rebuild dry-build \
       --flake git+file:///home/logoraz/.config/nixos#framework
}
```

### User Module: `home/logoraz/modules/gnome.nix`

```nix
{ config, pkgs, ... }:

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      cursor-theme = "Bibata-Modern-Classic";
    };
  };
}
```

### Main Config: `home/logoraz/home.nix`

```nix
{ config, pkgs, ... }:

{
  imports = [
    ./modules/shell.nix
    ./modules/gnome.nix
    ./modules/emacs.nix
    ./modules/terminal.nix
  ];

  home.username = "logoraz";
  home.homeDirectory = "/home/logoraz";

  home.packages = with pkgs; [
    # Your packages here
  ];

  home.stateVersion = "25.11";
}
```

## Future System Module Example

When you reach Phase 2, here's what `modules/desktop/gnome.nix` would look like:

```nix
{ config, pkgs, ... }:

{
  # GNOME Desktop
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Remove unwanted GNOME applications
  environment.gnome.excludePackages = with pkgs; [
    epiphany
    geary
    gnome-maps
    gnome-music
    # ... etc
  ];

  # System-wide cursor theme
  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };
}
```

Then in `hosts/framework/configuration.nix`:
```nix
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop/gnome.nix
    ../../modules/common.nix
  ];

  # Only Framework-specific settings here
  # ...
}
```

## Best Practices

1. **Keep it simple** - Only add complexity when you need it
2. **Separate concerns** - System config vs user config
3. **Use descriptive names** - `framework` clearly indicates which machine
4. **Version control** - Keep your configuration in git
5. **Regular commits** - Track changes over time

## Rebuild Commands

After making changes (from anywhere in the system):

```bash
# Preview changes (dry run)
sudo nixos-rebuild dry-build --flake ~/.config/nixos#framework

# Build and switch
sudo nixos-rebuild switch --flake ~/.config/nixos#framework

# Build for next boot (safer)
sudo nixos-rebuild boot --flake ~/.config/nixos#framework

# Or use the alias (if you added it to home.nix)
nixos-rebuild
```

## Git Workflow

```bash
cd ~/.config/nixos

# Make changes to your configs
nano home/logoraz/home.nix

# Stage and commit
git add -A
git commit -m "Added bash configuration"

# Rebuild
sudo nixos-rebuild switch --flake .#framework

# View generations
nixos-rebuild list-generations
```

## Notes

- Hardware-configuration.nix is auto-generated during installation
- Don't manually edit hardware-configuration.nix unless you know what you're doing
- The `#framework` part references the hostname defined in your flake.nix
- Home Manager configuration is integrated as a NixOS module (recommended approach)
