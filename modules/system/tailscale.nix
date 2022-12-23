{ config, lib, pkgs, user, ... }:
let
  this = config.system.tailscale;
in
with lib; {
  options = {
    system.tailscale.enable = mkOption {
      default = true;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    services.tailscale.enable = true;
  };
}
