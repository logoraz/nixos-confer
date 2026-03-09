{ config, pkgs, ... }:

let
  # Library paths for Common Lisp CFFI
  lispLibs = [
    "${pkgs.gmp}/lib"          # Required by sb-gmp (big number arithmetic)
    "${pkgs.mpfr}/lib"         # Required by sb-mpfr (precise floating point)
    "${pkgs.openssl.out}/lib"  # Required by clog/cl+ssl (cryptography/HTTPS)
    "${pkgs.sqlite.out}/lib"   # Required by mito/cl-dbi/ (database access)
  ];
  lispLibPath = builtins.concatStringsSep ":" lispLibs;
in
{
  # Bash configuration
  programs.bash = {
    enable = true;

    # Aliases
    shellAliases = {
      ll = "ls -lah";
      la = "ls -A";
      ".." = "cd ..";
      "..." = "cd ../..";
      # NixOS Convenient commands
      nixos-list = "nixos-rebuild list-generations";
      nixos-rollback = "sudo nixos-rebuild switch --rollback";
      nixos-update = "nix flake update ~/.config/nixos";
      nixos-show = "nix flake show ~/.config/nixos";
    };

    # Environment variables
    sessionVariables = {
      LC_COLLATE = "C";
      EDITOR = "emacsclient -c";
      VISUAL = "emacsclient -c";
      PATH = "$HOME/.local/bin:$PATH";
      LD_LIBRARY_PATH = ''${lispLibPath}:$LD_LIBRARY_PATH'';
    };

    # Extra bashrc content
    bashrcExtra = builtins.readFile ./bashrc.sh;

    # History settings
    historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
    historySize = 10000;
    historyFileSize = 100000;

    # This goes in .bash_profile (login shells)
    # profileExtra = builtins.readFile ./bash_profile.sh;
  };

  # Hide btop desktop entry - used solely in shells!
  xdg.desktopEntries.btop = {
    name = "btop";
    noDisplay = true;
  };

  # Future shell configurations can go here
  # programs.zsh = { ... };
  # programs.fish = { ... };
}
