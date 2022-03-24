{ config, pkgs, ... }: {
  imports = [
    ./boot.nix
    ./cli.nix
    ./displaymanager.nix
    ./flatpak.nix
    ./fonts.nix
    ./gtk.nix
    ./xdg.nix
    ./zfs.nix
  ];
}
