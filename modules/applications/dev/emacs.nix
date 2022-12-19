{ inputs, config, lib, pkgs, user, ... }:
# TODO Still need the following dependecies
#  - Language tools (grammer)
let
  this = config.my.application.emacs;
  graphical = config.my.graphical;
in
with lib; {
  options = {
    my.application.emacs.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];
    home-manager.users."${user.name}" = {
      programs.emacs = {
        package = pkgs.emacs28NativeComp;
        enable = true;
        extraPackages = epkgs: [ epkgs.vterm ];
      };

      home.packages = with pkgs; [
        (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
        editorconfig-core-c
        fd
        gdb
        graphviz
        html-tidy
        lldb
        python38
        ripgrep
        sqlite
        wordnet
      ];
    };
  };
}
