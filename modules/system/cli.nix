{ config, pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    cmake
    htop
    jq
    killall
    ripgrep
    silver-searcher
    tmux
    unzip
    zsh
  ];
}
