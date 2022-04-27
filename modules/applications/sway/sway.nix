{ config, lib, pkgs, ... }:
let
  cfg = config.this.application.sway;
  power = config.this.system.power;
  graphical = config.this.graphical;
  modifier = "Mod4";
  wallpaper = pkgs.fetchurl {
    url =
      "https://raw.githubusercontent.com/catppuccin/wallpapers/main/landscapes/evening-sky.png";
    sha256 = "sha256-fYMzoY3un4qGOSR4DMqVUAFmGGil+wUze31rLLrjcAc=";
  };

in with lib; {
  options = {
    this.application.sway.enable = mkOption {
      default = false;
      type = with types; bool;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.james = {
      home.sessionVariables = { XDG_CURRENT_DESKTOP = "sway"; };
      systemd.user.sessionVariables = { XDG_CURRENT_DESKTOP = "sway"; };
      wayland.windowManager.sway = {
        enable = true;
        package = null;
        wrapperFeatures.gtk = true;
        config = {
          # bars = [ ];
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
          input = {
            "1133:45079:MX_Master_Mouse" = {
              natural_scroll = "enable";
              accel_profile = "adaptive";
              pointer_accel = "-0.3";
            };
            "1:1:AT_Translated_Set_2_keyboard" = {
              xkb_options = "ctrl:nocaps";
            };
            "2:7:SynPS/2_Synaptics_TouchPad" = {
              dwt = "enabled";
              click_method = "clickfinger";
              natural_scroll = "enabled";
              middle_emulation = "enabled";
            };
          };
          gaps = {
            inner = 5;
            outer = 2;
          };
          # And import and scripts as scene here would be good.
          keybindings = mkOptionDefault {
            "${modifier}+q" = "kill";
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
          # https://github.com/gytis-ivaskevicius/nixfiles/blob/master/home-manager/i3-sway.nix
          modifier = "Mod4";
          output = { "eDP-1" = { bg = "${wallpaper} fill"; }; };
          terminal = "${pkgs.kitty}/bin/kitty";
          # https://rycee.gitlab.io/home-manager/options.html#opt-wayland.windowManager.sway.config.window.commands
          # window = { };
          startup = [{ command = "${pkgs.autotiling}/bin/autotiling"; }];
        };
      };

      home.packages = with pkgs; [
        autotiling
        brightness-sh
        dmenu
        grim
        imagemagick
        playerctl
        slurp
        sway-entry
        swayidle
        swaylock
        volume-sh
        wl-clipboard
        wofi
      ];
    };

    programs.light.enable = true;
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    systemd.user = {
      targets.sway-session = {
        description = "Sway compositor session";
        documentation = [ "man:systemd.special(7)" ];
        bindsTo = [ "graphical-session.target" ];
        wants = [ "graphical-session-pre.target" ];
        after = [ "graphical-session-pre.target" ];
      };
      services.sway = {
        enable = true;
        description = "Sway - Wayland window manager";
        documentation = [ "man:sway(5)" ];
        bindsTo = [ "default.target" ];
        wants = [ "graphical-session-pre.target" ];
        after = [ "graphical-session-pre.target" ];
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
    };

    users.users.james.extraGroups = [ "video" "audio" ];
  };
}
