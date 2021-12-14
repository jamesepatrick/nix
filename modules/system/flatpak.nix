{ config, lib, pkgs, ... }:
let
  cfg = config.systems.flatpak;
  graphical = config.graphical;
in with lib; {
  options = {
    systems.flatpak = {
      enable = mkOption {
        default = graphical.enable;
        type = with types; bool;
        description = "When they tried to do docker for GUIs";
      };
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
