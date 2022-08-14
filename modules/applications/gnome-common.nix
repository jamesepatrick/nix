{ config, lib, pkgs, user, ... }:
let
  graphical = config.my.graphical;
  power = config.my.system.power;
  keyring = config.my.system.keyring;
in
with lib; {
  config = mkIf graphical.enable {
    services.gvfs.enable = true;

    home-manager.users."${user.name}" = {
      home.packages = with pkgs.gnome;
        [
          cheese
          file-roller
          gnome-bluetooth
          gnome-books
          gnome-boxes
          gnome-calendar
          gnome-characters
          gnome-color-manager
          gnome-common
          gnome-contacts
          gnome-control-center
          gnome-dictionary
          gnome-font-viewer
          gnome-keyring
          gnome-maps
          gnome-music
          iagno
          libgnome-keyring
          nautilus
          pomodoro
          sushi
        ] ++ optionals (power.enable) [ gnome-power-manager ]
        ++ optionals (keyring.enable) [ seahorse ];
    };
  };
}
