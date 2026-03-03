{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname / Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Locale / Time
  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # GNOME Desktop
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Audio (PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Printing
  services.printing.enable = true;

  # Firmware (Framework Laptop)
  services.fwupd.enable = true;
  hardware.enableAllFirmware = true;
  services.fwupd.extraRemotes = [ "lvfs-testing" ];

  # Flatpak + GNOME Software
  services.flatpak.enable = true;
  services.packagekit.enable = true;

  # User Account
  users.users.logoraz = {
    isNormalUser = true;
    description = "Erik P Almaraz";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # System Packages (system-level only)
  environment.systemPackages = with pkgs; [
    firefox
    git
    curl
    wget
    unzip

    # GNOME theming
    bibata-cursors
    gnome-themes-extra
  ];

  # System-wide cursor theme (GDM + GNOME)
  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  # Fonts (system-wide)
  fonts = {
    fontDir.enable = true;
    fontconfig.enable = true;

    packages = with pkgs; [
      fira-code
      iosevka
    ];
  };

  # Unfree Packages
  nixpkgs.config.allowUnfree = true;

  # SSH
  services.openssh.enable = true;

  # State Version
  system.stateVersion = "25.11";
}
