{ config, lib, pkgs, ... }:
let
  cfg = config.my.system.displaymanager;
  graphical = config.my.graphical;
in with lib; {
  options = {
    my.system.displaymanager.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager = { gdm.enable = true; };
    };
  };
}
