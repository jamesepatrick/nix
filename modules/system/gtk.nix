{ config, lib, pkgs, user, ... }:
let
  graphical = config.my.graphical;
  this = config.my.system.gtk;
in with lib; {
  config = mkIf graphical.enable {
    home-manager.users."${user.name}" = {
      gtk = {
        enable = true;
        gtk3.extraConfig = {
          gtk-fallback-icon-theme = "gnome";
          gtk-application-prefer-dark-theme = true;
          gtk-xft-hinting = 1;
          gtk-xft-hintstyle = "hintfull";
          gtk-xft-rgba = "none";
        };
        iconTheme = {
          package = pkgs.kora-icon-theme;
          name = "kora";
        };
        theme = {
          package = pkgs.dracula-theme;
          name = "Dracula";
        };
      };
    };
  };
}
