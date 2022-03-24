{ config, pkgs, ... }: {
  imports = [
    ./1password.nix
    ./emacs.nix
    ./firefox.nix
    ./gnome-common.nix
    ./kitty.nix
    ./nextcloud.nix
    ./spotify.nix
    ./sway
  ];
}
