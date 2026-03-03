{ config, pkgs, ... }:

{
  xdg.desktopEntries.lem = {
    name = "Lem";
    genericName = "Text Editor";
    exec = "lem";
    icon = "${./../../../assets/lem.svg}";
    terminal = false;
    categories = [ "Development" "TextEditor" ];
    comment = "Common Lisp Editor";
  };
}
