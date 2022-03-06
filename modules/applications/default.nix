{ config, pkgs, ... }: {
  imports = [
    ./emacs.nix
    ./firefox.nix
    ./gnome-common.nix
    ./kitty.nix
    ./nextcloud.nix
    ./sway
  ];
}
