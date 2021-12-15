{ config, pkgs, ... }: {
  imports = [ ./gtk.nix ./boot.nix ./xdg.nix ./flatpak.nix ];
}
