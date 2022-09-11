{ config, lib, pkgs, user, ... }:
let
  this = config.my.system.fprint;
in
with lib; {
  options.my.system.fprint.enable = mkEnableOption "FPrint Support";

  config = mkIf this.enable {
    environment.systemPackages = with pkgs; [ fprintd ];
    services.fprintd.enable = true;
  };
}
