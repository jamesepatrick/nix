{ config, lib, pkgs, ... }:
let
  cfg = config.this.application.i3.polybar;
  i3 = config.this.application.i3;
  colors = {
    alert = "#A54242";
    background = "#000000";
    background-alt = "#373B41";
    disabled = "#707880";
    foreground = "#C5C8C6";
    primary = "#F0C674";
    secondary = "#8ABEB7";
  };
in with lib; {
  options = {
    this.application.i3.polybar.enable = mkOption {
      default = i3.enable;
      type = with types; bool;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.james = {
      services.polybar = {
        enable = true;
        script = "polybar";
        package = pkgs.polybar.override {
          i3GapsSupport = true;
          alsaSupport = true;
          iwSupport = true;
          githubSupport = true;
        };
        config = {
          "bar/top" = {
            width = "100%";
            height = "12pt";
            background = "${colors.background}";
            foreground = "${colors.foreground}";
            line-size = "3pt";
            border-size = "1pt";
            border-color = "${colors.background}";
            padding-left = "0";
            padding-right = "1";
            module-margin = "1";
            separator = "|";
            separator-foreground = "${colors.disabled}";
            font-0 = "Hasklug Nerd Font:size=8;2";
            font-1 = "Font Awesome 5 Free:size=8;2";
            font-2 = "Font Awesome 5 Free Solid:style=Solid;size=8;2";
            font-3 = "Noto Sans:size=8;1";
            modules-left = "xworkspaces i3 xwindow";
            modules-right =
              "demo filesystem pulseaudio memory cpu wlan battery date";
            cursor-click = "pointer";
            cursor-scroll = "ns-resize";
            enable-ipc = "true";
            tray-position = "right";
          };
          "module/i3" = {
            type = "internal/i3";
            format = "<label-mode>";
          };
          "module/xworkspaces" = {
            type = "internal/xworkspaces";
            label-active = "%name%";
            label-active-background = "${colors.background-alt}";
            label-active-padding = "1";
            label-empty = "%name%";
            label-empty-foreground = "${colors.disabled}";
            label-empty-padding = "1";
            label-occupied = "%name%";
            label-occupied-padding = "1";
            label-urgent = "%name%";
            label-urgent-background = "${colors.alert}";
            label-urgent-padding = "1";
          };
          "module/xwindow" = {
            type = "internal/xwindow";
            label = "%title:0:60:...%";
          };
          "module/filesystem" = {
            type = "internal/fs";
            interval = "25";
            mount-0 = "/";
            label-mounted = "%{F#F0C674}%mountpoint%%{F-} %percentage_used%%";
            label-unmounted = "%mountpoint% not mounted";
            label-unmounted-foreground = "${colors.disabled}";
          };
          "module/pulseaudio" = {
            type = "internal/pulseaudio";
            format-volume-prefix = "VOL ";
            format-volume-prefix-foreground = "${colors.primary}";
            format-volume = "<label-volume>";
            label-volume = "%percentage%%";
            label-muted = "muted";
            label-muted-foreground = "${colors.disabled}";
          };
          "module/memory" = {
            type = "internal/memory";
            interval = "2";
            format-prefix = "RAM ";
            format-prefix-foreground = "${colors.primary}";
            label = "%percentage_used:2%%";
          };
          "module/cpu" = {
            type = "internal/cpu";
            interval = "2";
            format-prefix = "CPU ";
            format-prefix-foreground = "${colors.primary}";
            label = "%percentage:2%%";
          };
          "network-base" = {
            type = "internal/network";
            interval = "5";
            format-connected = "<label-connected>";
            format-disconnected = "<label-disconnected>";
            label-disconnected = "%{F#F0C674}%ifname%%{F#707880} disconnected";
          };
          "module/wlan" = {
            "inherit" = "network-base";
            interface-type = "wireless";
            label-connected = "%{F#F0C674}%ifname%%{F-} %essid% %local_ip%";
          };
          "module/battery" = {
            type = "internal/battery";
            format-charging = "<animation-charging> <label-charging>";
            format-discharging = "<ramp-capacity> <label-discharging>";
            ramp-capacity-0 = "";
            ramp-capacity-1 = "";
            ramp-capacity-2 = "";
            ramp-capacity-3 = "";
            ramp-capacity-4 = "";
            animation-charging-0 = "%{F#F0C674}%{F-}";
            animation-charging-1 = "";
            animation-charging-2 = "";
            animation-charging-3 = "";
            animation-charging-4 = "";
            animation-charging-framerate = "1500";
          };
          "module/demo" = {
            type = "custom/ipc";
            hook-0 = "echo foobar";
            hook-1 = "date +%s";
            hook-2 = "whoami";
            initial = "1";
            click-left = "#demo.hook.0";
            click-right = "#demo.hook.1";
            double-click-left = "#demo.hook.2";
          };
          "module/date" = {
            type = "internal/date";
            interval = "1";
            date = "%H:%M";
            date-alt = "%Y-%m-%d %H:%M:%S";
            label = "%date%";
            label-foreground = "${colors.primary}";
          };
        };
      };
    };
  };
}

# [settings]
# screenchange-reload = true
# pseudo-transparency = true

# ; vim:ft=dosini
