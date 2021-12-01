{ config, pkgs, ... }: {
  home-manager.users.james = {
    home.packages = with pkgs; [ dracula-theme ];
    home.sessionVariables = { GTK_THEME = "Dracula"; };

    xdg.configFile."gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=Dracula
      #gtk-icon-theme-name=
      #gtk-cursor-theme-name=
      gtk-fallback-icon-theme=gnome
      gtk-application-prefer-dark-theme=true
      gtk-xft-hinting=1
      gtk-xft-hintstyle=hintfull
      gtk-xft-rgba=none
    '';
  };
}
