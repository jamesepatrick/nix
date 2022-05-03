{ config, lib, pkgs, ... }: {
  imports = [ ./minimal.nix ];

  this = {
    graphical.enable = true;
    system.power.enable = true;
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
}
