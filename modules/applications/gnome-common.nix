{ config, lib, pkgs, user, ... }:
let
  gnomeExtras = config.my.application.gnome.extras;
  graphical = config.my.graphical;
  keyring = config.my.system.keyring;
  power = config.my.system.power;
in
with lib; {
  options = {
    my.application.gnome.extras = {
      enable = mkOption {
        default = graphical.enable;
        type = with types; bool;
      };

      pkgs = mkOption {
        default = with pkgs.gnome; [
          cheese
          file-roller
          gnome-books
          gnome-boxes
          gnome-music
          iagno
          pomodoro
        ];
        type = with types; listOf package;
      };
    };
  };
  config = mkIf graphical.enable {
    services.gvfs.enable = true;

    home-manager.users."${user.name}" = {
      home.packages = with pkgs.gnome;
        [
          gnome-bluetooth
          gnome-calendar
          gnome-characters
          gnome-color-manager
          gnome-common
          gnome-contacts
          gnome-dictionary
          gnome-font-viewer
          gnome-maps
          nautilus
          nautilus-python
          sushi
        ]
        ++ optionals (gnomeExtras.enable) gnomeExtras.pkgs
        ++ optionals (power.enable) [ gnome-power-manager ]
        ++ optionals (keyring.enable) [ gnome-keyring libgnome-keyring seahorse ];
    };
  };
}
