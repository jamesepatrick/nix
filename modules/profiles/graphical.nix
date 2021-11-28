{ config, pkgs, ... }: {
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako # notification daemon
      kitty
      dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
      wofi
    ];
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      alegreya
      fira-code
      fira-code-symbols
      hasklig
      inter
      liberation_ttf
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "inter" ];
        sansSerif = [ "alegreya" ];
        monospace = [ "hasklig" ];
      };
    };
  };
}
