{ config, lib, pkgs, user, ... }:
let
  this = config.my.system.yubikey;
  graphical = config.my.graphical;
in with lib; {
  options.my.system.yubikey.enable = mkEnableOption "Yubikey";

  config = mkIf this.enable (mkMerge [
    {
      services = {
        udev.packages = with pkgs; [ yubikey-personalization ];
        pcscd.enable = true;
      };
      hardware.gpgSmartcards.enable = true;
      security.pam = {
        yubico = {
          enable = true;
          mode = "challenge-response";
          # debug = true;
        };
      };

      environment.systemPackages = with pkgs; [ pinentry-curses yubico-pam ];
      home-manager.users."${user.name}".home.packages = with pkgs; [
        yubikey-manager
        yubikey-personalization
      ];
    }
    (mkIf graphical.enable {

      environment.systemPackages = with pkgs; [ pinentry-gnome3 ];

      home-manager.users."${user.name}".home = {
        packages = with pkgs; [
          yubikey-touch-detector
          yubikey-manager-qt
          yubikey-personalization-gui
        ];
      };

      systemd.user.services.touchthebutton = {
        enable = true;
        description = "YubiKey touch prompt";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart =
            "${pkgs.yubikey-touch-detector}/bin/yubikey-touch-detector -v -libnotify";
          RestartSec = 5;
          Restart = "always";
        };
      };
    })
  ]);
}
