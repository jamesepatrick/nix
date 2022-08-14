{ config, pkgs, lib, user, ... }:
let
  this = config.my.application.firefox.tridactyl;
  firefox = config.my.application.firefox;
in
with lib; {
  options = {
    my.application.firefox.tridactyl.enable = mkOption {
      default = firefox.enable;
      type = with types; bool;
      description = "";
    };
  };

  config = mkIf this.enable {
    # firefox.pkg =
    #   pkgs.firefox.override { this = { enableTridactylNative = true; }; };
    home-manager.users."${user.name}" = {
      programs.firefox = {
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [ tridactyl ];
      };

      home.packages = with pkgs; [ tridactyl-native ];

      # This is a bit silly as this is currently managed by my make dot config.
      xdg.configFile."tridactyl/tridactylrc".source = pkgs.fetchurl {
        url =
          "https://git.jpatrick.io/james/dotfiles/raw/branch/master/tridactyl/tridactylrc";
        sha256 = "sha256-iOBd/yEvQP/Gn3+lS2Ztu9oslllZU4G7VnM4pTck+Tg=";
      };
    };
  };
}
