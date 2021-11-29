{ config, pkgs, ... }: {
  home-manager.users.james = {
    programs.firefox = {
      enable = true;

      package = pkgs.firefox.override {
        cfg = {
          enableTridactylNative = true;
          forceWayland = true;
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
  };
}
