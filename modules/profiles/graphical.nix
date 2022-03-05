{ config, lib, pkgs, ... }: {
  imports = [
    ../applications/firefox.nix
    ../applications/nextcloud.nix
    ../system/gtk.nix
    ./minimal.nix
  ];

  this.graphical.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
}
