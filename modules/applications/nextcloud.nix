{ config, lib, pkgs, ... }:
let
  cfg = config.application.nextcloud;
  graphical = config.this.graphical;
in with lib; {
  options = {
    application.nextcloud = {
      enable = mkOption {
        default = graphical.enable;
        type = with types; bool;
        description = "Dropbox for people who don't like dropbox";
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.james = {
      home.packages = with pkgs; [ nextcloud-client ];

      systemd.user.services = {
        nextcloud = {
          Unit = {
            Description = "Nextcloud - A slighly more GNU friendly dropbox";
            BindsTo = [ "graphical-session.target" ];
            Wants = [ "graphical-session-pre.target" ];
            After = [ "graphical-session-pre.target" ];
          };

          Service = {
            Type = "simple";
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
