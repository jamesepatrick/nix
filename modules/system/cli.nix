{ config, lib, pkgs, ... }:
let
  extras = config.my.system.cli.extras;
  ops = config.my.system.cli.ops;
in with lib; {
  options = {
    my.system.cli.extras = {
      enable = mkOption {
        default = true;
        type = with types; bool;
      };
      pkgs = mkOption {
        default = with pkgs; [
          busybox
          file
          fzf
          htop
          jq
          just
          ncdu
          pgcli
          postgresql
          ripgrep
          silver-searcher
          tailspin
          tmux
        ];
        type = with types; listOf package;
      };
    };
    my.system.cli.ops = {
      enable = mkOption {
        default = true;
        type = with types; bool;
      };
      pkgs = mkOption {
        default = with pkgs; [ terraform awscli ansible ];
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
      [ gnumake git git-lfs vim killall unzip zsh ]
      ++ optionals (extras.enable) extras.pkgs
      ++ optionals (ops.enable) ops.pkgs;
  };
}
