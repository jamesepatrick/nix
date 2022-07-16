{ config, lib, pkgs, ... }:
let
  cfg = config.system.flatpak;
  graphical = config.this.graphical;
in with lib; {
  options = {
    system.flatpak.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf cfg.enable {
    services.flatpak.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals =
        [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];
    };
  };

}
