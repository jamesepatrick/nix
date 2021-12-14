{ config, pkgs, ... }: {
  imports = [ ./sway ./emacs.nix ./firefox.nix ./nextcloud.nix ];
}
