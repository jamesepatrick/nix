{ config, lib, pkgs, ... }:
let graphical = config.this.graphical;
in {
  config = lib.mkIf graphical.enable {
    fonts = {
      enableDefaultFonts = true;
      fonts = with pkgs; [
        alegreya
        fira-code
        fira-code-symbols
        font-awesome
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
  };
}
