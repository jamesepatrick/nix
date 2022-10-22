{ config, lib, pkgs, user, ... }:
let
  this = config.my.application.guitar;
  graphical = config.my.graphical;
in
with lib; {
  options = {
    my.application.guitar.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    home-manager.users."${user.name}".home.packages = with pkgs; [
      tuxguitar
      musescore
      lilypond-with-fonts
    ];
  };
}
