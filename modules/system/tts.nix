# This is currently WIP. Larynx is installed but its having difficultly reading the pre-trained model objects.
# 
# ➜ larynx -v "scottish_english_male-glow_tts" "test"
# terminate called after throwing an instance of 'std::runtime_error'
#   what():  Model file doesn't exist
# zsh: IOT instruction (core dumped)  larynx -v "scottish_english_male-glow_tts" "test"
{ config, user, lib, pkgs, ... }:
let
  this = config.my.system.power;
  trained_voice_pack = pkgs.fetchzip {
    url =
      "https://github.com/rhasspy/larynx/releases/download/2021-03-28/en-us_scottish_english_male-glow_tts.tar.gz";
    sha256 = "sha256-AMIo16cCN4D+gHlaag7IK+yS+T0rnitc0pUtFsrJdiw=";
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
