{ config, lib, pkgs, ... }:
let extras = config.my.system.cli.extras;
in
with lib; {
  options = {
    my.system.cli.extras = {
      enable = mkOption {
        default = true;
        type = with types; bool;
      };
      pkgs = mkOption {
        default = with pkgs; [
          htop
          jq
          ripgrep
          silver-searcher
          tmux
        ];
        type = with types; listOf package;
      };
    };
  };
  config = {

    programs.zsh = {
      enable = true;
      enableCompletion = true;
    };

    environment.systemPackages = with pkgs;
      [ gnumake git vim killall unzip zsh ]
      ++ optionals (extras.enable) extras.pkgs;
  };
}
