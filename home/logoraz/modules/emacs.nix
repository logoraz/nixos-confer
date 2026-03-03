{ config, pkgs, ... }:

{
  # Hide Emacs (Client) launcher
  xdg.desktopEntries.emacsclient = {
    name = "Emacs (Client)";
    noDisplay = true;
  };
}
