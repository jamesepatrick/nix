{ config, lib, pkgs, user, ... }:
let
  this = config.my.application.activitywatch;
  graphical = config.my.graphical;
in with lib; {
  options = {
    my.application.activitywatch.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    home-manager.users."${user.name}".home.packages = with pkgs; [
      activitywatch
      aw-qt
    ];

    systemd.user.services.activitywatch = {
      enable = true;
      description = "Spying on yourself";
      wantedBy = [ "i3-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.activitywatch}/bin/aw-qt
        '';
        RestartSec = 5;
        Restart = "always";
      };
    };
  };
}
