{ config, pkgs, lib, ... }:
let
  cfg = config.this.application.firefox;
  graphical = config.this.graphical;
  sway_cfg = config.this.application.sway;
in with lib; {
  options = {
    this.application.firefox = {
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
          https-everywhere
          onepassword-password-manager
          simple-tab-groups
          tridactyl
          ublock-origin
        ];

        profiles = {
          default = {
            name = "primary";
            id = 0;
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
