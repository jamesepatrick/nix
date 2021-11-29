{ config, pkgs, ... }: {

  environment.systemPackages = with pkgs; [ htop ripgrep jq silver-searcher ];
}
