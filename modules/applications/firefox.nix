{ config, pkgs, lib, user, ... }:
let
  cfg = config.my.application.firefox;
  graphical = config.my.graphical;
  tridactylConfig = pkgs.fetchurl {
    url =
      "https://git.jpatrick.io/james/dotfiles/raw/branch/master/tridactyl/tridactylrc";
    sha256 = "sha256-iOBd/yEvQP/Gn3+lS2Ztu9oslllZU4G7VnM4pTck+Tg=";
  };
in with lib; {
  options.my.application.firefox = {
    enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
    pkg = mkOption {
      default =
        pkgs.firefox.override { cfg = { enableTridactylNative = true; }; };
      type = with types; package;
    };
  };

  config = mkIf cfg.enable {
    environment.sessionVariables = { MOZ_USE_XINPUT2 = "1"; };

    home-manager.users."${user.name}" = {
      programs.firefox = {
        enable = true;
        package = cfg.pkg;
        profiles = {
          default = {
            name = "primary";
            id = 0;
            extensions = with pkgs.nur.repos.rycee.firefox-addons; [
              #https-everywhere # Current disabled has its been removed from Rycee's Firefox Addons.
              onepassword-password-manager
              simple-tab-groups
              tridactyl
              ublock-origin
            ];
            settings = {
              # Don't ask for download location
              "browser.download.useDownloadDir" = false;
              # Use Darkmode
              "browser.in-content.dark-mode" = true;
              # Disable Top Stories on homepage.
              "browser.newtabpage.activity-stream.feeds.section.topstories" =
                false;
              # Disable Feed on homepage.
              "browser.newtabpage.activity-stream.feeds.sections" = false;
              # Disable pocket on homepage.
              "browser.newtabpage.activity-stream.section.highlights.includePocket" =
                false;
              # Enable DRM
              "media.eme.enabled" = true;
              "media.gmp-widevinecdm.visible" = true;
              "media.gmp-widevinecdm.enabled" = true;
              # Disable built-in form-filling
              "signon.autofillForms" = false;
              # Disable built-in password manager
              "signon.rememberSignons" = false;
              # No really use Darkmode
              "ui.systemUsesDarkTheme" = true; # Dark mode
            };
          };
          # Stripped down configuration running vanilla firefox.
          secondary = {
            name = "secondary";
            id = 1;
            extensions = with pkgs.nur.repos.rycee.firefox-addons;
              [
                #https-everywhere # Current disabled has its been removed from Rycee's Firefox Addons.
                ublock-origin
              ];
            #extensions = with pkgs.nur.repos.rycee.firefox-addons;
            #[ ublock-origin ];
          };
        };
      };

      home.packages = with pkgs; [ tridactyl-native ];

      xdg.configFile."tridactyl/tridactylrc".source = tridactylConfig;
    };
  };
}
