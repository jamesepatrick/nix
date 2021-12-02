{ config, pkgs, ... }: {
  home-manager.users.james = { home.packages = with pkgs; [ waybar ]; };
}
