{ config, lib, pkgs, ... }:
let
  this = config.system.flatpak;
  graphical = config.my.graphical;
in with lib; {
  options = {
    system.flatpak.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    services.flatpak.enable = true;
    xdg.portal = { enable = true; };
  };

}
