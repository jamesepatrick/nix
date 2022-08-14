{ config, lib, pkgs, ... }:
let
  this = config.my.application.zeal;
  graphical = config.my.graphical;
in with lib; {
  options = {
    my.application.zeal.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    home-manager.users.james.home.packages = with pkgs; [ zeal ];
  };
}
