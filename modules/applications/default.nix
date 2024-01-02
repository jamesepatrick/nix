{ config, lib, pkgs, user, ... }:
let
  this = config.my.application.apps;
  graphical = config.my.graphical;
in with lib; {
  options = {
    my.application.apps.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    home-manager.users."${user.name}" = {
      home.packages = with pkgs; [
        # Guitar
        tuxguitar
        musescore
        lilypond-with-fonts
        # Chat
        discord
        element-desktop
        whatsapp-for-linux
        # Misc
        krita
        todoist
        insomnia
        zeal
        newsflash
      ];
    };
  };
}
