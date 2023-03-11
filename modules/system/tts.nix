{ config, lib, pkgs, ... }:
let
  this = config.my.system.power;
  trained_voice_pack = pkgs.fetchurl {
    url =
      "https://github.com/rhasspy/larynx/releases/download/2021-03-28/en-us_scottish_english_male-glow_tts.tar.gz";
    sha256 = "sha256-7TMubQ6qXdItU5BKDp8Xfq+gYN6IvJ7/q3XmbY/F8IY=";
  };
in with lib; {
  options.my.system.tts.enable = mkEnableOption "Enable TTS";

  config = mkIf this.enable {
    environment.systemPackages = with pkgs; [ larynx ];

    home-manager.users."${user.name}" = {
      home.file.voicePack = {
        target = ".local/share/larynx/voices/";
        source = trained_voice_pack;
      };
    };
  };

}
