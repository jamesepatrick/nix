{ config, lib, pkgs, ... }:
let
  this = config.my.application.zathura;
  graphical = config.my.graphical;
in with lib; {
  options = {
    my.application.zathura.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    home-manager.users.james = { programs.zathura = { enable = true; }; };
  };
}
