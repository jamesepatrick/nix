{ config, lib, pkgs, ... }:
let
  cfg = config.my.application.spotify;
  graphical = config.my.graphical;
in with lib; {
  options = {
    my.application.spotify.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.james = { home.packages = with pkgs; [ spotify ]; };

    # Local discovery - https://nixos.wiki/wiki/Spotify
    networking.firewall.allowedTCPPorts = [ 57621 ];
  };
}
