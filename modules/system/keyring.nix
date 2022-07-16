{ config, lib, pkgs, ... }:
let cfg = config.this.system.keyring;
in with lib; {
  options.this = {
    system.keyring.enable = mkOption {
      default = true;
      type = with types; bool;
    };
  };
  # options.this.system.keyring.enable = mkEnableOption "keyring";

  config = mkIf cfg.enable { services.gnome.gnome-keyring.enable = true; };
}
