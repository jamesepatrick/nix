{ config, pkgs, lib, user, ... }:
let
  cfg = config.my.application.firefox;
  activitywatch = config.my.application.activitywatch;
  graphical = config.my.graphical;
  _settings = {
    "browser.download.useDownloadDir" = false; # Don't ask for download location
    "browser.in-content.dark-mode" = true; # Use Darkmode
    "browser.newtabpage.activity-stream.feeds.section.topstories" =
      false; # Disable Top Stories on homepage.
    "browser.newtabpage.activity-stream.feeds.sections" =
      false; # Disable Feed on homepage.
    "browser.newtabpage.activity-stream.section.highlights.includePocket" =
      false; # Disable pocket on homepage.
    # Enable DRM
    "media.eme.enabled" = true;
    "media.gmp-widevinecdm.visible" = true;
    "media.gmp-widevinecdm.enabled" = true;
    "signon.autofillForms" = false; # Disable built-in form-filling
    "signon.rememberSignons" = false; # Disable built-in password manager
    "ui.systemUsesDarkTheme" = true; # No really use Darkmode
  };
in with lib; {
  options.my.application.firefox = {
    enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf cfg.enable {
    environment.sessionVariables = { MOZ_USE_XINPUT2 = "1"; };
    home-manager.users."${user.name}" = {
      home.packages = with pkgs; [ qrencode ];
      xdg.configFile."tridactyl/tridactylrc".source = ./tridactylrc;
      xdg.configFile."tridactyl/themes".source = ./themes;

      programs.firefox = {
        enable = true;
        package = pkgs.firefox.override {
          nativeMessagingHosts = [ pkgs.tridactyl-native ];
        };

        profiles = {
          default = {
            name = "primary";
            id = 0;
            extensions = with pkgs.nur.repos.rycee.firefox-addons;
              [
                onepassword-password-manager
                simple-tab-groups
                tridactyl
                ublock-origin
              ] ++ optionals (activitywatch.enable) [ aw-watcher-web ];
            settings = _settings;
          };

          # Stripped down configuration running (basically) default firefox. Helpful for testing.
          secondary = {
            name = "secondary";
            id = 1;
            extensions = with pkgs.nur.repos.rycee.firefox-addons;
              [
                ublock-origin # Have you see the net without it?
              ];
            settings = _settings;
          };
        };
      };
    };
  };
}
