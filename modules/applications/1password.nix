{ config, lib, pkgs, user, ... }:
let
  this = config.my.application.onepassword;
  yubikey = config.my.system.yubikey;
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
      environment.systemPackages = with pkgs; [ _1password ];
      programs._1password = {
        enable = true;
        gid = 5001;
      };
      users.users."${user.name}".extraGroups = [ "onepassword-cli" ];
    })
    (mkIf this.gui.enable {
      programs._1password-gui = {
        enable = true;
        gid = 5000;
        polkitPolicyOwners = [ "${user.name}" ];
      };
      users.users."${user.name}".extraGroups = [ "onepassword" ];

      security.pam.services."1password".yubicoAuth = yubikey.enable;

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
