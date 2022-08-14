{ config, lib, pkgs, ... }:
let
  cfg = config.my.application.zeal;
  graphical = config.my.graphical;
in with lib; {
  options = {
    my.application.zeal.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.james.home.packages = with pkgs; [ zeal ];
  };
}
