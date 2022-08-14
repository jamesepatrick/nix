{ options, config, lib, pkgs, ... }:
let
  this = config.my.application.gammastep;
  i3 = config.my.application.i3;
in with lib; {
  options = {
    my.application.gammastep.enable = mkOption {
      default = i3.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    home-manager.users.james = {
      services.gammastep = {
        enable = true;
        provider = "geoclue2";
        tray = true;
      };
    };

    services.geoclue2.enable = true;

    systemd.user.services.gammastep = {
      enable = true;
      description = "Nightly color shifting";
      wantedBy = [ "i3-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.gammastep}/bin/gammastep
        '';
        RestartSec = 5;
        Restart = "always";
      };
    };

  };
}
