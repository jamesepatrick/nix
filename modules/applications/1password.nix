{ config, lib, pkgs, user, ... }:
let
  this = config.my.application.onepassword;
  graphical = config.my.graphical;
  enable = (this.gui.enable || this.cli.enable);
in
with lib; {
  options = {
    my.application.onepassword.gui.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
    my.application.onepassword.cli.enable = mkOption {
      default = (graphical.enable || this.gui.enable);
      type = with types; bool;
    };
  };

  config = mkIf enable (mkMerge [
    (mkIf this.cli.enable {
      home-manager.users."${user.name}".home.packages = with pkgs; [ _1password ];
    })
    (mkIf this.gui.enable {
      home-manager.users."${user.name}" = {
        home.packages = with pkgs; [ _1password-gui ];
      };
      systemd.user.services._1password = {
        enable = true;
        description = "1password for linux. (PAM not included)";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${pkgs._1password-gui}/bin/1password --silent";
          RestartSec = 5;
          Restart = "always";
        };
      };
    })
  ]);
}
