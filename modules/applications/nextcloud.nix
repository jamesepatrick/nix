{ config, lib, pkgs, ... }:
let
  this = config.my.application.nextcloud;
  graphical = config.my.graphical;
in with lib; {
  options = {
    my.application.nextcloud.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    home-manager.users.james = {
      home.packages = with pkgs; [ nextcloud-client ];
    };

    systemd.user.services = {
      nextcloud = {
        enable = true;
        description =
          "Nextcloud Client - A slightly more GNU friendly dropbox ";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.nextcloud-client}/bin/nextcloud --background";
          Environment = "QT_XCB_GL_INTEGRATION=none";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}
