{ inputs, config, lib, pkgs, user, ... }:
# TODO Still need the following dependecies
#  - Language tools (grammer)
let
  this = config.my.application.emacs;
  graphical = config.my.graphical;
in with lib; {
  options = {
    my.application.emacs.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];

    environment.systemPackages = with pkgs; [ nodePackages.mermaid-cli ];

    home-manager.users."${user.name}" = {
      programs.emacs = {
        package = pkgs.emacs29-gtk3;
        enable = true;
        extraPackages = epkgs: [ epkgs.vterm ];
      };

      home.packages = with pkgs; [
        (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
        cmake
        editorconfig-core-c
        fd
        gdb
        graphviz
        html-tidy
        lldb
        pandoc
        python38
        ripgrep
        sqlite
        wordnet
      ];
    };
  };
}
