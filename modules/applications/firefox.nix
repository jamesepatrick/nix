{ config, pkgs, lib, ... }:
let
  cfg = config.application.firefox;
  graphical = config.graphical;
  sway_cfg = config.applications.sway;
in with lib; {
  options = {
    application.firefox = {
      enable = mkOption {
        default = graphical.enable;
        type = with types; bool;
        description = "";
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.james = {
      # Enable touch controls.
      home.sessionVariables = { MOZ_USE_XINPUT2 = 1; };

      programs.firefox = {
        enable = true;
        package = pkgs.firefox.override {
          cfg = {
            enableTridactylNative = true;
            forceWayland = sway_cfg.enable;
          };
        };

        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          onepassword-password-manager
          https-everywhere
          ublock-origin
          tridactyl
        ];

        profiles = {
          default = {
            name = "primary";
            id = 0;
            settings = {
              "browser.download.useDownloadDir" =
                false; # Ask for download location
              "browser.in-content.dark-mode" = true; # Dark mode
              "browser.newtabpage.activity-stream.feeds.section.topstories" =
                false; # Disable top stories
              "browser.newtabpage.activity-stream.feeds.sections" = false;
              "browser.newtabpage.activity-stream.feeds.system.topstories" =
                false; # Disable top stories
              "browser.newtabpage.activity-stream.section.highlights.includePocket" =
                false; # Disable pocket
              "media.eme.enabled" = true; # Enable DRM
              "media.gmp-widevinecdm.visible" = true; # Enable DRM
              "media.gmp-widevinecdm.enabled" = true; # Enable DRM
              "signon.autofillForms" = false; # Disable built-in form-filling
              "signon.rememberSignons" =
                false; # Disable built-in password manager
              "ui.systemUsesDarkTheme" = true; # Dark mode
            };
          };
        };
      };

      # This is a bit silly as this is currently managed by my make dot config.
      xdg.configFile."tridactyl/tridactylrc".source = pkgs.fetchurl {
        url =
          "https://git.jpatrick.io/james/dotfiles/raw/branch/master/tridactyl/tridactylrc";
        sha256 = "sha256-iOBd/yEvQP/Gn3+lS2Ztu9oslllZU4G7VnM4pTck+Tg=";
      };
    };
  };
}
