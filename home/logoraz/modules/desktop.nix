{ config, pkgs, ... }:

{
  # Hide LibreOffice Start Center - keep individual apps
  xdg.desktopEntries.startcenter = {
    name = "LibreOffice Start Center";
    noDisplay = true;
  };
}
