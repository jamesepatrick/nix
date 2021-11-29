{ config, lib, pkgs, ... }: {
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
  };

  home-manager.users.james = {

    home.packages = with pkgs; [
      autotiling
      dmenu
      kitty
      mako
      swayidle
      swaylock
      wl-clipboard
      wofi
    ];
  };
}
