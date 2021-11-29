{ config, lib, pkgs, ... }: {
  imports = [
    ../applications/firefox.nix
    ../boot.nix
    ../cli.nix
    ../fonts.nix
    ../sway.nix
    ./minimal.nix
  ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
}
