{ config, lib, pkgs, ... }:
let
  graphical = config.this.graphical;
  power = config.this.system.power;
in with lib; {
  config = mkIf graphical.enable {
    home-manager.users.james = {
      home.packages = with pkgs.gnome;
        [
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
          iagno
          libgnome-keyring
          nautilus
          pomodoro
          seahorse
          sushi
        ] ++ optionals (power.enable) [ gnome-power-manager ];
    };
  };
}
