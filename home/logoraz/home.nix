{ config, pkgs, ... }:

{
  imports = [
    ./modules/gnome.nix
    ./modules/shell.nix
    ./modules/emacs.nix
    ./modules/terminal.nix
    ./modules/desktop.nix
    ./modules/lem.nix
  ];

  home.username = "logoraz";
  home.homeDirectory = "/home/logoraz";

  # User Packages (apps you use, not system services)
  home.packages = with pkgs; [
    # Lisp Toolchain
    clasp-common-lisp
    sbcl
    ecl

    # Lisp IDE/Editors
    lem-webview
    emacs-pgtk

    # Python Toolchain
    python3
    python3Packages.python-lsp-server


    # Other toolchains
    openssl
    sqlite
    graphviz
    gmp
    mpfr

    # GNOME customization
    gnome-tweaks

    # Office Suite
    libreoffice-fresh

    # Creative Tools
    inkscape
    gimp
    obs-studio

    # Base
    mpv
  ];

  # Home Manager state version
  home.stateVersion = "25.11";
}
