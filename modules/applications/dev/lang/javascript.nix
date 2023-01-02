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
    home-manager.users."${user.name}" = { lib, ... }: {
      # See https://nixos.wiki/wiki/Node.js
      home.activation.npm-global = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD mkdir -p $HOME/.npm-global
        $DRY_RUN_CMD npm set prefix $HOME/.npm-global
      '';

      home.packages = with pkgs; [
        nodePackages.js-beautify
        nodePackages.npm
        nodePackages.stylelint
        nodePackages.vue-cli
        nodejs
        yarn
      ];
    };
  };
}
