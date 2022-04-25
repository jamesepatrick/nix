{ config, lib, pkgs, ... }:
let
  cfg = config.this.application.kdeconnect;
  graphical = config.this.graphical;
in with lib; {
  options = {
    this.application.kdeconnect.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf cfg.enable {

    environment.sessionVariables = optionals (graphical.protocol == "Wayland") {
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    };
    # home-manager.users.james = {
    #   services.kdeconnect = {
    #     indicator = true;
    #     enable = true;
    #   };
    # };

    # networking.firewall = {
    #   allowedTCPPortRanges = [{
    #     from = 1714;
    #     to = 1764;
    #   }];
    #   allowedUDPPortRanges = [{
    #     from = 1714;
    #     to = 1764;
    #   }];
    # };
    programs.kdeconnect.enable = true;
  };
}
