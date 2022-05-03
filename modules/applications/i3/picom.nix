{ config, lib, pkgs, ... }:
let
  cfg = config.this.application.i3.picom;
  i3 = config.this.application.i3;

in with lib; {
  options = {
    this.application.i3.picom.enable = mkOption {
      default = i3.enable;
      type = with types; bool;
    };
  };

  config = mkIf cfg.enable {
    services.picom = {
      enable = true;
      backend = "glx";
      vSync = true;
    };
  };
}
