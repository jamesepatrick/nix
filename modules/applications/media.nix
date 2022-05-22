{ config, lib, pkgs, ... }:
let
  cfg = config.this.application.media;
  graphical = config.this.graphical;
in with lib; {
  options = {
    this.application.media.enable = mkOption {
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
