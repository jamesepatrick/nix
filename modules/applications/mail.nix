{ config, lib, pkgs, user, ... }:
let
  this = config.my.application.mail;
  graphical = config.my.graphical;
  secrets = config.my.secrets;
in with lib; {
  options = {
    my.application.mail = {
      maildir = mkOption { default = "/home/${user.name}/.cache/mail"; };
      enable = mkOption {
        default = graphical.enable;
        type = with types; bool;
      };
    };
  };

  config = mkIf this.enable {
    assertions = [{
      assertion = config.my.system.secrets.enable;
      message = "This module requires the use of secrets";
    }];
    home-manager.users."${user.name}" = {
      home.packages = with pkgs; [
        isync
        key
        libsecret # used to access gnome keychain
        mu
        protonmail-bridge
      ];

      programs.mbsync.enable = true;
      programs.mu.enable = true;

      accounts.email = {
        maildirBasePath = "${this.maildir}";
        accounts."ProtonMail" = {
          address = secrets.email.primary;
          aliases = secrets.email.aliases;
          userName = secrets.email.primary;
          passwordCommand =
            "${pkgs.libsecret}/bin/secret-tool lookup proto IMAP host 127.0.0.1";
          primary = true;
          realName = "${name}";
          mbsync = {
            enable = true;
            create = "both";
            expunge = "both";
            patterns = [ "*" ];
          };
          mu.enable = true;
          imap = {
            host = "127.0.0.1";
            port = 1143;
            tls = {
              enable = true;
              useStartTls = true;
              certificatesFile =
                "/home/${user.name}/.config/protonmail/bridge/cert.pem";
            };
          };
        };
      };

      services = {
        mbsync = {
          enable = true;
          frequency = "*:0/15";
          preExec = "${pkgs.isync}/bin/mbsync -Ha";
          postExec = "${pkgs.mu}/bin/mu index";
        };
      };

    };
    systemd.user.services = {
      protonbridge = {
        enable = true;
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart =
            "${pkgs.protonmail-bridge}/bin/protonmail-bridge --noninteractive";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}
