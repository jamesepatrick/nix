{ config, lib, pkgs, ... }:
let graphical = config.this.graphical;
in with lib; {
  config = mkIf graphical.enable {
    home-manager.users.james = {
      home.packages = with pkgs.gnome; [
        #gnome-common
        cheese
        file-roller
        gnome-bluetooth
        gnome-books
        gnome-boxes
        gnome-calendar
        gnome-characters
        gnome-color-manager
        gnome-contacts
        gnome-control-center
        gnome-dictionary
        #gnome-documents
        gnome-font-viewer
        gnome-keyring
        gnome-maps
        gnome-music
        gnome-power-manager # conditioanl if upower is used
        iagno
        libgnome-keyring
        nautilus
        pomodoro
        seahorse
        sushi
      ];
    };
  };
}
