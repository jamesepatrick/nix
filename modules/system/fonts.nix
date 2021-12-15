{ config, lib, pkgs, ... }:
let graphical = config.graphical;
in {
  config = lib.mkIf graphical.enable {
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
  };
}
