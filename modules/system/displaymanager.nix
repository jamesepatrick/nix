{ config, lib, pkgs, ... }:
let
  this = config.my.system.displaymanager;
  graphical = config.my.graphical;
in with lib; {
  options = {
    my.system.displaymanager.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    services.xserver = {
      enable = true;
      displayManager = { gdm.enable = true; };
    };
  };
}
