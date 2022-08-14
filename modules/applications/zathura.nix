{ config, lib, pkgs, user, ... }:
let
  this = config.my.application.zathura;
  graphical = config.my.graphical;
in
with lib; {
  options = {
    my.application.zathura.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    home-manager.users."${user.name}" = { programs.zathura = { enable = true; }; };
  };
}
