{ config, lib, pkgs, user, ... }:
let
  graphical = config.my.graphical;
  this = config.my.system.gtk;
in
with lib; {
  options.my.system.gtk = {
    theme = mkOption {
      default = "Dracula";
      type = with types; str;
    };
  };
  config = mkIf graphical.enable {
    home-manager.users."${user.name}" = {
      gtk.enable = true;
      home.packages = with pkgs; [ dracula-theme kora-icon-theme ];
      home.sessionVariables = { GTK_THEME = "${this.theme}"; };
      systemd.user.sessionVariables = { GTK_THEME = "${this.theme}"; };

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
