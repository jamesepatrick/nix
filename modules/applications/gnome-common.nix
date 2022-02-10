{ config, lib, pkgs, ... }:
let graphical = config.this.graphical;
in with lib; {
  config = mkIf graphical.enable {
    home-manager.users.james = {
      home.packages = with pkgs; [
        gnome.file-roller
        gnome.gnome-bluetooth
        gnome.gnome-calendar
        gnome.gnome-characters
        gnome.gnome-color-manager
        gnome.gnome-contacts
        gnome.gnome-dictionary
        gnome.gnome-font-viewer
        gnome.gnome-keyring
        gnome.gnome-maps
        gnome.libgnome-keyring
        gnome.nautilus
      ];
    };
  };
}
