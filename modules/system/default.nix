{ config, pkgs, ... }: {
  imports =
    [ ./gtk.nix ./boot.nix ./xdg.nix ./flatpak.nix ./zfs.nix ./fonts.nix ];
}
