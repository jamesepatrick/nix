{ config, lib, pkgs, ... }:
let
  cfg = config.my.lang.bash;
  graphical = config.my.graphical;
in with lib; {
  options = {
    my.lang.bash.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.james = {
      home.packages = with pkgs; [
        nodePackages.bash-language-server
        shellcheck
      ];
    };
  };
}
