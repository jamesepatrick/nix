{ config, lib, pkgs, ... }:
let
  cfg = config.this.lang.bash;
  graphical = config.this.graphical;
in with lib; {
  options = {
    this.lang.javascript = {
      enable = mkOption {
        default = graphical.enable;
        type = with types; bool;
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.james = {
      home.packages = with pkgs; [
        nodePackages.npm
        nodePackages.vue-cli
        nodejs
        yarn
      ];
    };
  };
}
