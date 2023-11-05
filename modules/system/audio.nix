{ config, lib, pkgs, user, ... }:
let graphical = config.my.graphical;
in with lib; {
  config = mkIf graphical.enable {

    # Enable sound.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };
  };
}
