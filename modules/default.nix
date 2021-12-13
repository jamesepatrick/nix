{ config, pkgs, ... }: {
  imports = [
    ./system
    ./applications
    # TODO Refactor everything after this.
    ./boot.nix
    ./cli.nix
    ./fonts.nix
    ./zfs.nix
  ];
}
