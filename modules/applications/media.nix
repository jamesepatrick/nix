{ config, lib, pkgs, user, ... }:
let
  this = config.my.application.media;
  graphical = config.my.graphical;
in
with lib; {
  options = {
    my.application.media.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    home-manager.users."${user.name}" = {
      programs.mpv = {
        enable = true;
        scripts = with pkgs.mpvScripts; [ mpris thumbnail ];
      };
      home.packages = with pkgs; [
        jellyfin-mpv-shim
        jellyfin-media-player
        jftui
      ];
    };
  };
}
