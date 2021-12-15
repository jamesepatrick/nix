{ config, lib, pkgs, ... }:

let grpahical = config.graphical;
in {
  imports = [
    ../applications/firefox.nix
    ../applications/nextcloud.nix
    ../cli.nix
    ../fonts.nix
    ../system/gtk.nix
    ./minimal.nix
  ];

  graphical.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
}
