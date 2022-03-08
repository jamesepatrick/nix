{ config, pkgs, ... }: {
  imports = [ ./dunst.nix ./sway.nix ./gammastep.nix ./mako.nix ./waybar.nix ];
}
