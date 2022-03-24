{ config, lib, pkgs, ... }:
let
  cfg = config.this.lang.golang;
  graphical = config.this.graphical;
in with lib; {
  options = {
    this.lang.golang.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.james = {
      programs.go = {
        enable = true;
        goPath = ".local/go";
        goBin = ".local/bin.go";
      };

      home.packages = with pkgs; [
        air
        gcc
        gocode
        golangci-lint
        gomodifytags
        gomodifytags
        gopls
        gore
        gotests
      ];
    };
  };
}
