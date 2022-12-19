{ config, lib, pkgs, user, ... }:
let
  this = config.my.application.chat;
  graphical = config.my.graphical;
in
with lib; {
  options = {
    my.application.chat.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    environment.systemPackages = with pkgs;
      [
        discord
        element-desktop
        whatsapp-for-linux
      ];
  };
}
