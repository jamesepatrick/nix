{ config, pkgs, lib, ... }:
let
  cfg = config.this.application.firefox.tridactyl;
  firefox = config.this.application.firefox;
in with lib; {
  options = {
    this.application.firefox.tridactyl.enable = mkOption {
      default = firefox.enable;
      type = with types; bool;
      description = "";
    };
  };

  config = mkIf cfg.enable {
    # firefox.pkg =
    #   pkgs.firefox.override { cfg = { enableTridactylNative = true; }; };
    home-manager.users.james = {
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
