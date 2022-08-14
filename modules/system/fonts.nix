{ config, lib, pkgs, ... }:
let graphical = config.my.graphical;
in {
  config = lib.mkIf graphical.enable {
    fonts = {
      enableDefaultFonts = true;
      fonts = with pkgs; [
        alegreya
        fira-code
        fira-code-symbols
        font-awesome
        (nerdfonts.override { fonts = [ "Hasklig" ]; })
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
