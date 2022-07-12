{ inputs, config, lib, pkgs, ... }:
# TODO Still need the following dependecies
#  - Language tools (grammer)
let
  cfg = config.this.application.emacs;
  graphical = config.this.graphical;
in with lib; {
  options = {
    this.application.emacs.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];
    home-manager.users.james = {
      programs.emacs = {
        package = pkgs.emacs28NativeComp;
        enable = true;
        extraPackages = epkgs: [ epkgs.vterm ];
      };

      home.packages = with pkgs; [
        (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
        editorconfig-core-c
        fd
        graphviz
        html-tidy
        ripgrep
        sqlite
        wordnet
      ];
    };
  };
}
