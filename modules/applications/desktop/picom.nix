{ config, lib, pkgs, ... }:
let
  this = config.my.application.i3.picom;
  i3 = config.my.application.i3;

in with lib; {
  options = {
    my.application.i3.picom.enable = mkOption {
      default = i3.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    services.picom = {
      enable = true;
      backend = "glx";
      fade = true;
      fadeDelta = 4;
      inactiveOpacity = 0.95;
      shadow = true;
      vSync = true;
    };
  };
}
