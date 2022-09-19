{ config, lib, pkgs, user, ... }:
let
  this = config.my.application.music;
  graphical = config.my.graphical;
in
with lib; {
  options = {
    my.application.music.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    home-manager.users."${user.name}" = {
      home.packages = with pkgs; [
        spotify
        pithos
        picard
        pantheon.elementary-music
        somafm-cli
      ];
    };

    # Local discovery - https://nixos.wiki/wiki/Spotify
    networking.firewall.allowedTCPPorts = [ 57621 ];
  };
}
