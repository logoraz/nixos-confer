{ config, pkgs, ... }:

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Fira Code:size=9";
        dpi-aware = "no";
        initial-window-size-chars = "140x40"; # Columns x Rows in Characters
      };

      bell = {
        urgent = "no";     # Don't mark window as urgent on bell
        notify = "no";     # Don't send desktop notification
        visual = "no";     # Don't flash the screen
      };

      scrollback = {
        lines = 5000;      # Keep 5000 lines of history (default is 1000)
      };

      csd = {
        preferred = "client";      # Use client-side decorations
        color = "2e3440";        # Dark title bar color
        border-width = 1;
        border-color = "81a1c1"; # Subtle border
        button-color = "88c0d0"; # Window button color
      };

      colors = {
        alpha = 0.85;
        background = "383838";  # Nord Black Polar Night
        foreground = "eceff4";  # Nord White Snow Storm
      };
    };
  };

  # Set as default terminal
  home.sessionVariables = {
    TERMINAL = "foot";
  };

  # Hide extra Foot desktop entries
  xdg.desktopEntries = {
    footclient = {
      name = "Foot Client";
      noDisplay = true;
    };

    foot-server = {
      name = "Foot Server";
      noDisplay = true;
    };
  };
}
