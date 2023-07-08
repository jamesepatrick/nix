{ config, lib, pkgs, user, ... }:
let
  this = config.my.application.gnome;
  graphical = config.my.graphical;
  music = config.my.application.music;
  mail = config.my.application.mail;
  i3 = config.my.application.i3;
  power = config.my.system.power;
in with lib; {
  options = {
    my.application.gnome = {
      extras = {
        enable = mkOption {
          default = graphical.enable;
          type = with types; bool;
        };
        pkgs = mkOption {
          default = with pkgs.gnome; [
            cheese
            file-roller
            gnome-boxes
            gnome-music
            iagno
            pomodoro
            gnome-maps
            pkgs.newsflash
          ];
          type = with types; listOf package;
        };
      };
      keyring.enable = mkOption {
        default = true;
        type = with types; bool;
      };
    };
  };
  config = mkIf graphical.enable (mkMerge [
    (mkIf i3.enable {
      services.xserver.desktopManager.gnome.flashback.customSessions = [{
        wmName = "i3";
        wmLabel = "i3";
        wmCommand =
          "${config.services.xserver.windowManager.i3.package}/bin/i3";
        enableGnomePanel = false;
      }];
    })
    {
      programs.dconf.enable = true;
      services = {
        gvfs.enable = true;
        gnome = {
          core-utilities.enable = true;
          evolution-data-server.enable = true;
          gnome-online-accounts.enable = true;
          gnome-keyring.enable = this.keyring.enable;
        };
      };

      environment.systemPackages = with pkgs; [
        pkgs.glib
        pkgs.gnome-online-accounts
        pkgs.gsettings-desktop-schemas
      ];

      home-manager.users."${user.name}" = {
        home.packages = with pkgs.gnome;
          [
            gnome-bluetooth
            gnome-calendar
            gnome-characters
            gnome-color-manager
            gnome-common
            gnome-contacts
            gnome-control-center
            gnome-dictionary
            gnome-disk-utility
            gnome-font-viewer
            gnome-screenshot
            gnome-session
            nautilus
            nautilus-python
            gnome-tweaks
            pkgs.gnome-menus
            pkgs.mate.mate-polkit
            sushi
          ] ++ optionals (this.extras.enable) this.extras.pkgs
          ++ optionals (power.enable) [ gnome-power-manager ]
          ++ optionals (mail.enable) [
            geary
            pkgs.evolution-data-server-gtk4
            pkgs.evolution
          ] ++ optionals (music.enable) [ gnome-music pkgs.tracker ]
          ++ optionals (this.keyring.enable) [
            gnome-keyring
            libgnome-keyring
            seahorse
          ];

        xdg.mimeApps = {
          enable = true;
          defaultApplications = {
            "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
          };
        };
      };
      systemd.user.services.mate_polkit = {
        enable = true;
        description = "Mate Polkit - the Gnome one is a bit ugly";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart =
            "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
          RestartSec = 5;
          Restart = "always";
        };
      };
    }
  ]);
}
