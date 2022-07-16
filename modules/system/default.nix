{ config, pkgs, ... }: {
  imports = [
    ./boot.nix
    ./cli.nix
    ./displaymanager.nix
    ./flatpak.nix
    ./fonts.nix
    ./gtk.nix
    ./keyring.nix
    ./power.nix
    ./xdg.nix
    ./yubikey.nix
    ./zfs.nix
  ];
}
