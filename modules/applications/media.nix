{ config, lib, pkgs, ... }:
let
  cfg = config.my.application.media;
  graphical = config.my.graphical;
in with lib; {
  options = {
    my.application.media.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.james = {
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
