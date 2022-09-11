{ config, lib, pkgs, user, ... }:
let
  this = config.my.application.kdeconnect;
  graphical = config.my.graphical;
in
with lib; {
  options = {
    my.application.kdeconnect.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    programs.kdeconnect.enable = true;

    systemd.user.services = {
      kdeconnect = {
        enable = true;
        description = "KDE Connect";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.kdeconnect}/bin/kdeconnect-indicator";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}
