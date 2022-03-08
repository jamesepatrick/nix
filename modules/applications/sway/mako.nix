{ options, config, lib, pkgs, ... }:
let
  cfg = config.this.application.mako;
  sway = config.this.application.sway;
in with lib; {
  options = {
    this.application.mako = {
      enable = mkOption {
        default = sway.enable;
        type = with types; bool;
        description = "testing one two three";
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.james = {
      systemd.user.startServices = true;
      programs.mako = {
        enable = true;
        width = 450;
        padding = "20,20";
        backgroundColor = "#161720ee";
        borderColor = "#12151a";
        textColor = "#d6e5fb";
        defaultTimeout = 8000;
        progressColor = "over #d6e5fb";
        layer = "overlay";
        groupBy = "summary";
        extraConfig = ''
          [hidden]
          background-color=#bfbfbfff
          format=+ %h

          [urgency=high]
          background-color=#1f212eee
          border-color=#f0185a00
          text-color=#f0185a
          ignore-timeout=true
          default-timeout=0

          [!expiring]
          background-color=#555555ff
          text-color=#eeeeeeff

          [grouped]
          format=<b>%s</b> ✖ %g\n%b
        '';
      };

      home.packages = with pkgs; [ libnotify ];
    };
    systemd.user.services.mako = {
      enable = true;
      description = "Mako foo";
      wantedBy = [ "sway-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.mako}/bin/mako
        '';
        RestartSec = 5;
        Restart = "always";
      };
    };

    # systemd.user.services.mako = {
    #   enable = true;
    #   description = "Mako - Notificaitons for Wayland";
    #   documentation = [ "man:mako(5)" ];
    #   partOf = [ "sway-session.target" ];
    #   bindsTo = [ "sway-session.target" ];
    #   environment.PATH = lib.mkForce null;
    #   serviceConfig = {
    #     ExecStart = "${pkgs.mako}/bin/mako";
    #     Restart = "on-failure";
    #     RestartSec = 1;
    #     TimeoutStopSec = 10;
    #     Type = "simple";
    #   };
    # };
  };
}
