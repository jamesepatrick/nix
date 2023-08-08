{ config, lib, pkgs, user, ... }:
let this = config.system.vpn;
in with lib; {
  options.system.vpn.enable = mkOption {
    default = true;
    type = with types; bool;
  };

  config = mkIf this.enable { services.mullvad-vpn.enable = true; };
}
