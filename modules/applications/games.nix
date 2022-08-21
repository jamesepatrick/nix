{ config, lib, pkgs, user, ... }:
let
  this = config.my.application.games;
  graphical = config.my.graphical;
in
with lib; {
  options = {
    my.application.games.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    programs.steam.enable = true;
    environment.systemPackages = with pkgs;
      [
        bottles
        dosbox
        minigalaxy
        shattered-pixel-dungeon
        wine64
        wineWowPackages.full
        winetricks
      ];
  };
}
