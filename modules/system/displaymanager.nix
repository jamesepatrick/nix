{ config, lib, pkgs, ... }:
let
  cfg = config.system.displaymanager;
  graphical = config.this.graphical;
in with lib; {
  options = {
    system.displaymanager.enable = mkOption {
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
