{ config, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };
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
