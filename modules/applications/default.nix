{ config, pkgs, ... }: {
  imports = [
    ./1password.nix
    ./blueman.nix
    ./dunst.nix
    ./emacs.nix
    ./gammastep.nix
    ./gnome-common.nix
    ./kdeconnect.nix
    ./kitty.nix
    ./media.nix
    ./nextcloud.nix
    ./spotify.nix
    ./zathura.nix
    ./zeal.nix

    ./i3
    ./firefox
  ];
}
