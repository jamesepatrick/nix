# Need to read?
{ config, pkgs, ... }: {
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
