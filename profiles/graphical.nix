{ config, lib, pkgs, ... }: {
  imports = [ ./minimal.nix ];

  my = {
    graphical.enable = true;
    system.power.enable = true;
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
}
