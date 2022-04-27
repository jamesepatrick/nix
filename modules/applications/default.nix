{ config, pkgs, ... }: {
  imports = [
    ./1password.nix
    ./dunst.nix
    ./emacs.nix
    ./firefox.nix
    ./gnome-common.nix
    ./kdeconnect.nix
    ./kitty.nix
    ./nextcloud.nix
    ./spotify.nix

    ./i3
    ./sway
  ];
}
