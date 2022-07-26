{ config, lib, pkgs, ... }:
let
  cfg = config.this.application.blueman;
  graphical = config.this.graphical;
in with lib; {
  options = {
    this.application.blueman.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    home-manager.users.james = { home.packages = with pkgs; [ blueman ]; };
    fileSystems."var/lib/bluetooth" = {
      device = "/persist/var/lib/bluetooth";
      options = [ "bind" "noauto" "x-systemd.automount" ];
      noCheck = true;
    };
  };
}
