{ inputs, config, lib, pkgs, ... }:
# TODO Still need the following dependecies
#  - Language tools (grammer)
let
  cfg = config.this.application.emacs;
  graphical = config.this.graphical;
in with lib; {
  options = {
    this.application.emacs = {
      enable = mkOption {
        default = graphical.enable;
        type = with types; bool;
        description = "Insert joke about emacs is an operating system.";
      };
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];
    home-manager.users.james = {
      programs.emacs = {
        package = pkgs.emacsPgtkGcc;
        enable = true;
        extraPackages = epkgs: [ epkgs.vterm ];
      };

      home.packages = with pkgs; [
        (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
        ripgrep
        sqlite
        wordnet
      ];
    };
  };
}
