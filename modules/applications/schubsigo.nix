{ config, lib, pkgs, user, ... }:
let
  this = config.my.application.schubsigo;
  graphical = config.my.graphical;
in
with lib; {
  options = {
    my.application.schubsigo.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    home-manager.users."${user.name}" = {
      home.packages = with pkgs; [ schubsigo ];
    };

    systemd.user.services = {
      schubsigo = {
        enable = true;
        description =
          "A Pushover notification client written in go";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.Schubsigo}/bin/Schubsigo -no-tray";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}
