{ config, lib, pkgs, ... }: {
  home-manager.users.james = {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

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
