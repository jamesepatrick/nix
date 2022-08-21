{ config, lib, pkgs, user, ... }:
let
  this = config.my.system.fprint;
in
with lib; {
  options.my = {
    system.fprint.enable = mkOption {
      default = false;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    services.fprintd.enable = true;
  };
}
