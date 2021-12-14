{ config, pkgs, ... }: {
  imports =
    [ ./firefox.nix ./mako.nix ./nextcloud.nix ./waybar.nix ./emacs.nix ];
}
