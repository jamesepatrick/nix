{ config, lib, pkgs, ... }:
let
  cfg = config.my.application.i3.picom;
  i3 = config.my.application.i3;

in with lib; {
  options = {
    my.application.i3.picom.enable = mkOption {
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
