{ config, pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    htop
    ripgrep
    jq
    unzip
    silver-searcher
  ];
}
