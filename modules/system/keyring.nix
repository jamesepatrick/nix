{ config, lib, pkgs, ... }:
let this = config.my.system.keyring;
in with lib; {
  options.my = {
    system.keyring.enable = mkOption {
      default = true;
      type = with types; bool;
    };
  };
  # options.my.system.keyring.enable = mkEnableOption "keyring";

  config = mkIf this.enable { services.gnome.gnome-keyring.enable = true; };
}
