{ config, lib, pkgs, ... }:
let
  cfg = config.this.application.zathura;
  graphical = config.this.graphical;
in with lib; {
  options = {
    this.application.zathura.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.james = { programs.zathura = { enable = true; }; };
  };
}
