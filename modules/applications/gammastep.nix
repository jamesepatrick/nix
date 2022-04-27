{ options, config, lib, pkgs, ... }:
let
  cfg = config.this.application.gammastep;
  sway = config.this.application.sway;
  i3 = config.this.application.i3;
in with lib; {
  options = {
    this.application.gammastep.enable = mkOption {
      default = i3.enable || sway.enable;
      type = with types; bool;
    };
  };

  config = mkIf cfg.enable {
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
      wantedBy = [ "sway-session.target" "i3-session.target" ];
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
