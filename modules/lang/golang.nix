{ config, lib, pkgs, ... }:
let
  cfg = config.my.lang.golang;
  graphical = config.my.graphical;
in with lib; {
  options = {
    my.lang.golang.enable = mkOption {
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
        gocode
        golangci-lint
        gomodifytags
        gomodifytags
        gopls
        gore
        gotests
      ];
    };
    environment.systemPackages = with pkgs; [ gcc gccgo go libcap ];
  };
}
