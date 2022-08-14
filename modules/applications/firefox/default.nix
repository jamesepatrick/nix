{ config, pkgs, lib, ... }:
let
  cfg = config.my.application.firefox;
  graphical = config.my.graphical;
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

    home-manager.users.james = {
      programs.firefox = {
        enable = true;
        package = cfg.pkg;

        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          https-everywhere
          onepassword-password-manager
          simple-tab-groups
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
    };
  };
}
