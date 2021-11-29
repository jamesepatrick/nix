# Home Manager programs.firefox style
programs.firefox = {
  enable = true;
  package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
    forceWayland = true;
    extraPolicies = {
      ExtensionSettings = {};
    };
  };
};
