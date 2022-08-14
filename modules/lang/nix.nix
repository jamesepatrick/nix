{ config, lib, pkgs, ... }:
let
  this = config.my.lang.nix;
  graphical = config.my.graphical;
in with lib; {
  options = {
    my.lang.nix.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    environment.systemPackages = with pkgs; [ nixfmt rnix-lsp ];
  };
}
