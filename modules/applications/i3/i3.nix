{ config, lib, pkgs, ... }:
let
  cfg = config.this.application.i3;
  graphical = config.this.graphical;
  modifier = "Mod4";
  wallpaper = pkgs.fetchurl {
    url =
      "https://raw.githubusercontent.com/catppuccin/wallpapers/main/landscapes/evening-sky.png";
    sha256 = "sha256-fYMzoY3un4qGOSR4DMqVUAFmGGil+wUze31rLLrjcAc=";
  };

in with lib; {
  options = {
    this.application.i3.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf cfg.enable {
    programs.dconf.enable = true;
    programs.light.enable = true;

    services.xserver = {
      enable = true;

      xkbOptions = "ctrl:nocaps";
      libinput = {
        enable = true;
        touchpad = {
          naturalScrolling = true;
          clickMethod = "clickfinger";
          tapping = false;
          tappingDragLock = false;
        };
      };

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [
          dmenu # application launcher most people use
          feh
          i3blocks # if you are planning on using i3blocks over i3status
          i3lock # default i3 screen locker
          i3status # gives you the default i3 status bar
          playerctl
          xclip
          xdotool
        ];
      };
    };

    home-manager.users.james = {
      xsession.windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        config = {
          colors = {
            focusedInactive = {
              background = "#1E1E2E";
              border = "#1E1E2E";
              childBorder = "#1E1E2E";
              indicator = "#1E1E2E";
              text = "#C9CBFF";
            };
            unfocused = {
              background = "#1E1E2E";
              border = "#1E1E2E";
              childBorder = "#1E1E2E";
              indicator = "#1E1E2E";
              text = "#C9CBFF";
            };
            focused = {
              background = "#131020";
              border = "#131020";
              childBorder = "#131020";
              indicator = "#131020";
              text = "#ABE9B3";
            };
            urgent = {
              background = "#F28FAD";
              border = "#F28FAD";
              childBorder = "#F28FAD";
              indicator = "#F28FAD";
              text = "#ABE9B3";
            };
          };
          fonts = {
            names = [ "Alegreya" "FontAwesome" ];
            size = 9.0;
          };
          gaps = {
            smartBorders = "off";
            smartGaps = true;
            inner = 5;
            outer = 2;
          };
          terminal = "${pkgs.kitty}/bin/kitty";
          keybindings = mkOptionDefault {
            "${modifier}+h" = "focus left";
            "${modifier}+k" = "focus up";
            "${modifier}+j" = "focus down";
            "${modifier}+l" = "focus right";
            "${modifier}+shift+h" = "move left";
            "${modifier}+shift+k" = "move up";
            "${modifier}+shift+j" = "move down";
            "${modifier}+shift+l" = "move right";

            "${modifier}+s" = "split h";
            "${modifier}+q" = "kill";
            "${modifier}+alt+s" = "layout stacking";
            "${modifier}+d" = "focus mode_toggle";
            "${modifier}+a" = "focus parent";
            "${modifier}+shift+s" = "sticky toggle";
            "${modifier}+shift+f" = "floating toggle";
            "${modifier}+space" =
              "exec $(${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu)";
            Pause = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
            XF86AudioLowerVolume = "exec ${pkgs.volume-sh}/bin/volume.sh down";
            XF86AudioMute = "exec ${pkgs.volume-sh}/bin/volume.sh mute";
            XF86AudioRaiseVolume = "exec ${pkgs.volume-sh}/bin/volume.sh up";
            XF86MonBrightnessDown =
              "exec ${pkgs.brightness-sh}/bin/brightness.sh down";
            XF86MonBrightnessUp =
              "exec ${pkgs.brightness-sh}/bin/brightness.sh up";
          };
          modifier = "Mod4";
          startup = [
            { command = "${pkgs.autotiling}/bin/autotiling"; }
            { command = "${pkgs.feh}/bin/feh --bg-scale ${wallpaper}"; }
          ];
        };
      };
    };

    systemd.user = {
      targets.i3-session = {
        description = "i3 compositor session";
        documentation = [ "man:systemd.special(7)" ];
        bindsTo = [ "graphical-session.target" ];
        wants = [ "graphical-session-pre.target" ];
        after = [ "graphical-session-pre.target" ];
      };
      services.i3 = {
        enable = true;
        description = "i3 - i3 window manager";
        documentation = [ "man:i3(5)" ];
        bindsTo = [ "default.target" ];
        wants = [ "graphical-session-pre.target" ];
        after = [ "graphical-session-pre.target" ];
        environment.PATH = lib.mkForce null;
        serviceConfig = {
          Type = "simple";
          ExecStart =
            "${pkgs.dbus}/bin/dbus-run-session ${pkgs.i3}/bin/i3 --debug";
          ExecStopPost =
            "/usr/bin/env systemctl --user unset-environment DISPLAY I3SOCK ";
          NotifyAccess = "all";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };

    users.users.james.extraGroups = [ "video" "audio" ];
  };
}
