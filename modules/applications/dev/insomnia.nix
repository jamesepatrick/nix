{ config, lib, pkgs, user, ... }:
let
  this = config.my.application.insomnia;
  graphical = config.my.graphical;
in
with lib; {
  options = {
    my.application.insomnia.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    home-manager.users."${user.name}".home.packages = with pkgs; [ insomnia ];
  };
}
