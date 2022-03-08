{ config, lib, pkgs, ... }:
let
  cfg = config.this.application.sway;
  graphical = config.this.graphical;
in with lib; {
  options = {
    this.application.sway = {
      enable = mkOption {
        # TODO base on graphical
        default = graphical.enable;
        type = with types; bool;
        description = "testing one two three";
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.james = {
      home.sessionVariables = {
        MOZ_ENABLE_WAYLAND = 1;
        XDG_CURRENT_DESKTOP = "sway";
      };

      home.packages = with pkgs; [
        autotiling
        dmenu
        grim
        imagemagick
        slurp
        gammastep
        swayidle
        swaylock
        playerctl
        wl-clipboard
        wofi
        (writeTextFile {
          name = "sway-entry";
          destination = "/bin/sway-entry";
          executable = true;
          text = ''
            #! ${pkgs.bash}/bin/bash

            # first import environment variables from the login manager
            # function is currently deprecated. It should be rolled back in the future
            systemctl --user import-environment

            # then start the service
            exec systemctl --user start sway.service
          '';
        })
      ];
    };

    programs.light.enable = true;

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true; # so that gtk works properly
    };

    systemd.user.targets.sway-session = {
      description = "Sway compositor session";
      documentation = [ "man:systemd.special(7)" ];
      bindsTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
    };

    systemd.user.services.sway = {
      enable = true;
      description = "Sway - Wayland window manager";
      documentation = [ "man:sway(5)" ];
      bindsTo = [ "default.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
      # We explicitly unset PATH here, as we want it to be set by
      # systemctl --user import-environment in startsway
      environment.PATH = lib.mkForce null;
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway --debug";
        ExecStopPost =
          "/usr/bin/env systemctl --user unset-environment SWAYSOCK DISPLAY I3SOCK WAYLAND_DISPLAY";
        NotifyAccess = "all";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    users.users.james.extraGroups = [ "video" "audio" ];
  };
}

