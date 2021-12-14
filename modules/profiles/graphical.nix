{ config, lib, pkgs, ... }: {
  imports = [
    ../applications/firefox.nix
    ../applications/nextcloud.nix
    ../boot.nix
    ../cli.nix
    ../fonts.nix
    ../system/gtk.nix
    ./minimal.nix
  ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
}
