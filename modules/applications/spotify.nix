{ config, lib, pkgs, ... }:
let
  cfg = config.this.application.spotify;
  graphical = config.this.graphical;
in with lib; {
  options = {
    this.application.spotify.enable = mkOption {
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
