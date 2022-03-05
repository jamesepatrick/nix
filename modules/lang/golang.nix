{ config, lib, pkgs, ... }:
let
  cfg = config.this.lang.golang;
  graphical = config.this.graphical;
in with lib; {
  options = {
    this.lang.golang = {
      enable = mkOption {
        default = graphical.enable;
        type = with types; bool;
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.james = {
      programs.go = {
        enable = true;
        goPath = ".local/go";
        goBin = ".local/bin.go";
        # packages = {
        #   "golang.org/x/tools/cmd/godoc";
        #   "golang.org/x/tools/cmd/goimports";
        #   "golang.org/x/tools/cmd/gorename";
        #   "golang.org/x/tools/cmd/guru";
        # };
      };

      home.packages = with pkgs; [
        air
        gocode
        golangci-lint
        gomodifytags
        gomodifytags
        gore
        gotests
      ];
    };
  };
}
