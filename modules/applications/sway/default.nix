{ config, pkgs, ... }: {
  imports = [ ./sway.nix ./gammastep.nix ./mako.nix ./waybar.nix ];
}
