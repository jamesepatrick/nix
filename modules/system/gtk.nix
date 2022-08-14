{ config, lib, pkgs, user, ... }:
let graphical = config.my.graphical;
in
with lib; {
  config = mkIf graphical.enable {
    home-manager.users."${user.name}" = {
      home.packages = with pkgs; [ dracula-theme kora-icon-theme ];
      home.sessionVariables = { GTK_THEME = "Dracula"; };
      systemd.user.sessionVariables = { GTK_THEME = "Dracula"; };

      xdg.configFile."gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name=Dracula
        gtk-icon-theme-name=kora
        gtk-fallback-icon-theme=gnome
        gtk-application-prefer-dark-theme=true
        gtk-xft-hinting=1
        gtk-xft-hintstyle=hintfull
        gtk-xft-rgba=none
      '';
    };
  };
}
