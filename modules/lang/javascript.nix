{ config, lib, pkgs, user, ... }:
let
  this = config.my.lang.bash;
  graphical = config.my.graphical;
in
with lib; {
  options = {
    my.lang.javascript.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    home-manager.users."${user.name}" = {
      home.packages = with pkgs; [
        nodePackages.npm
        nodePackages.vue-cli
        nodejs
        yarn
      ];
    };
  };
}
