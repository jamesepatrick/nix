{ config, lib, pkgs, ... }:
let
  cfg = config.this.application.i3;
  graphical = config.this.graphical;
  modifier = "Mod4";
  wallpaper = pkgs.fetchurl {
    url =
      "https://raw.githubusercontent.com/catppuccin/wallpapers/main/landscapes/evening-sky.png";
    sha256 = "sha256-fYMzoY3un4qGOSR4DMqVUAFmGGil+wUze31rLLrjcAc=";
  };

in with lib; {
  options = {
    this.application.i3.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkif cfg.enable {
    this.graphical.protocol = "X11";
    home-manager.users.james = {
      xsession.windowManager.i3 = {
        enable = true;
        package = "pkgs.i3-gaps";
      };
    };
  };
}
