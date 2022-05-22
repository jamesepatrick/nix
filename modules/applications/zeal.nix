{ config, lib, pkgs, ... }:
let
  cfg = config.this.application.zeal;
  graphical = config.this.graphical;
in with lib; {
  options = {
    this.application.zeal.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.james.home.packages = with pkgs; [ zeal ];
  };
}
