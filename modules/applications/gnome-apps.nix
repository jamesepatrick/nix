{ config, lib, pkgs, user, ... }:
let
  this = config.my.application.gnome;
  graphical = config.my.graphical;
  music = config.my.application.music;
  mail = config.my.application.mail;
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
  config = mkIf graphical.enable {
    programs.dconf.enable = true;
    services = {
      gvfs.enable = true;
      gnome = {
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
          gnome-maps
          gnome-screenshot
          gnome-session
          nautilus
          nautilus-python
          pkgs.gnome-menus
          pkgs.mate.mate-polkit
          sushi
        ] ++ optionals (this.extras.enable) this.extras.pkgs
        ++ optionals (power.enable) [ gnome-power-manager ]
        ++ optionals (mail.enable) [ geary ]
        ++ optionals (music.enable) [ gnome-music pkgs.tracker ]
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
  };
}
