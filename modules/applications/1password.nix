{ config, lib, pkgs, ... }:
let
  cfg = config.this.application.onepassword;
  graphical = config.this.graphical;
  enable = (cfg.gui.enable || cfg.cli.enable);
in with lib; {
  options = {
    this.application.onepassword.gui.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
    this.application.onepassword.cli.enable = mkOption {
      default = (graphical.enable || cfg.gui.enable);
      type = with types; bool;
    };
  };

  config = mkIf enable (mkMerge [
    (mkIf cfg.cli.enable {
      home-manager.users.james.home.packages = with pkgs; [ _1password ];
    })
    (mkIf cfg.gui.enable {
      home-manager.users.james = {
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
