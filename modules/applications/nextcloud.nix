{ config, lib, pkgs, ... }:
let
  cfg = config.this.application.nextcloud;
  graphical = config.this.graphical;
in with lib; {
  options = {
    this.application.nextcloud.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.james = {
      home.packages = with pkgs; [ nextcloud-client ];

      systemd.user.services = {
        nextcloud = {
          Unit = {
            Description = "Nextcloud - A slightly more GNU friendly dropbox";
            BindsTo = [ "graphical-session.target" ];
            Wants = [ "graphical-session-pre.target" ];
            After = [ "graphical-session-pre.target" ];
          };

          Service = {
            Type = "simple";
            Description = "Nextcloud - A slightly more GNU friendly dropbox";
            ExecStart = "${pkgs.nextcloud-client}/bin/nextclient --background";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };
      };
    };
  };
}
