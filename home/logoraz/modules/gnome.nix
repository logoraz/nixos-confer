{ config, pkgs, ... }:

{
  # Ensure cursor size is set for GTK applications
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
  };

  # GNOME user settings
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      cursor-theme = "Bibata-Modern-Classic";
      cursor-size = 24;
    };

    # Shell theme (optional, but keeps things consistent)
    "org/gnome/shell/extensions/user-theme" = {
      name = "Adwaita-dark";
    };
  };
}
