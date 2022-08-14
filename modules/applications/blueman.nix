{ config, lib, pkgs, ... }:
let
  this = config.my.application.blueman;
  graphical = config.my.graphical;
in with lib; {
  options = {
    my.application.blueman.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    hardware.bluetooth.enable = true;
    home-manager.users.james = { home.packages = with pkgs; [ blueman ]; };
    fileSystems."var/lib/bluetooth" = {
      device = "/persist/var/lib/bluetooth";
      options = [ "bind" "noauto" "x-systemd.automount" ];
      noCheck = true;
    };
  };
}
