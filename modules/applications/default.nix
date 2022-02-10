{ config, pkgs, ... }: {
  imports =
    [ ./sway ./emacs.nix ./gnome-common.nix ./firefox.nix ./nextcloud.nix ];
}
