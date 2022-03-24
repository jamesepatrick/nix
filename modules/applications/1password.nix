{ config, lib, pkgs, ... }:
let
  cfg = config.this.application.onepassword;
  graphical = config.this.graphical;
  enable = (cfg.gui.enable || cfg.cli.enable);
in with lib; {
  options = {
    this.application.onepassword.gui.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
    this.application.onepassword.cli.enable = mkOption {
      default = (graphical.enable || cfg.gui.enable);
      type = with types; bool;
    };
  };

  config = mkIf (cfg.gui.enable || cfg.cli.enable) {
    home-manager.users.james = {
      home.packages = with pkgs; [ _1password _1password-gui ];
    };
  };
}
