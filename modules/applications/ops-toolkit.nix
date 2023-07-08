{ config, lib, pkgs, user, ... }:
let
  this = config.my.application.ops-toolkit;
  graphical = config.my.graphical;
in with lib; {
  options = {
    my.application.ops-toolkit.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    environment.systemPackages = (with pkgs; [ terraform awscli ansible ])
    #|| (with pkgs.terraform-providers; [ aws digitalocean dns sentry tailscale]);
    ;
  };
}
