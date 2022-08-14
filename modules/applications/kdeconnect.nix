{ config, lib, pkgs, ... }:
let
  this = config.my.application.kdeconnect;
  graphical = config.my.graphical;
in with lib; {
  options = {
    my.application.kdeconnect.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
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
