{ config, lib, pkgs, user, ... }:
let
  this = config.my.lang.golang;
  graphical = config.my.graphical;
in
with lib; {
  options = {
    my.lang.golang.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    home-manager.users."${user.name}" = {
      programs.go = {
        enable = true;
        goPath = ".local/go";
        goBin = ".local/bin.go";
      };

      home.packages = with pkgs; [
        air
        delve
        gocode
        golangci-lint
        gomodifytags
        gopls
        gore
        gotests
      ];
    };
    environment.systemPackages = with pkgs; [ gcc gccgo go libcap ];
  };
}
