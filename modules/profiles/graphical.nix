{ config, lib, pkgs, ... }: {
  imports = [ ../boot.nix ../cli.nix ../fonts.nix ../sway.nix ./minimal.nix ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
}
