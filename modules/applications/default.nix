{ config, pkgs, ... }: {
  imports = [
    ./1password.nix
    ./dunst.nix
    ./emacs.nix
    ./firefox.nix
    ./gammastep.nix
    ./gnome-common.nix
    ./kdeconnect.nix
    ./kitty.nix
    ./media.nix
    ./nextcloud.nix
    ./spotify.nix
    ./zeal.nix

    ./i3
  ];
}
