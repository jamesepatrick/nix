{ config, lib, pkgs, ... }: {
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
}
