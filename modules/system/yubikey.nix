{ config, lib, pkgs, ... }:
let
  this = config.my.system.yubikey;
  graphical = config.my.graphical;
in with lib; {
  options.my.system.yubikey.enable = mkEnableOption "Yubikey";

  config = mkIf this.enable {
    services.udev.packages = with pkgs; [ yubikey-personalization ];

    environment.shellInit = ''
      export GPG_TTY="$(tty)"
      gpg-connect-agent /bye
      export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
    '';

    programs = {
      ssh.startAgent = false;
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryFlavor = if graphical.enable then "gnome3" else "curses";
      };
    };

    # security.pam = {
    #   yubico = {
    #     enable = true;
    #     mode = "challenge-response";
    #     control = "required"; # oh boy.
    #   };
    # };

    environment.systemPackages = with pkgs;
      [ yubioath-desktop pinentry-curses ]
      ++ optionals (graphical.enable) [ pinentry-gnome ];

    home-manager.users.james.home = {
      packages = with pkgs;
        [ yubikey-manager yubikey-personalization ]
        ++ optionals (graphical.enable) [
          yubikey-manager-qt
          yubikey-personalization-gui
        ];
      file.".gnupg/gpg-agent.config" = {
        text = if graphical.enable then
          "pinentry-program ${pkgs.pinentry-gnome}/bin/pinentry"
        else
          "pinentry-program ${pkgs.pinentry-curses}/bin/pinentry";
      };
    };
  };
}
