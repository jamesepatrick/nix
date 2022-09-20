{ config, lib, pkgs, user, ... }:
let
  this = config.my.application.mail;
  graphical = config.my.graphical;
in
with lib; {
  options = {
    my.application.mail.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {

    home-manager.users."${user.name}" = {
      home.packages = with pkgs; [ protonmail-bridge mu isync ];

      programs.mbsync = {
        enable = true;
      };
      programs.mu.enable = true;

      # accounts.email.accounts."ProtonMail" = {
      #   address = "public@jpatrick.io";
      #   mu.enable = true;
      # };
    };


    systemd.user.services = {
      protonbridge = {
        enable = true;
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.protonmail-bridge}/bin/protonmail-bridge";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}
