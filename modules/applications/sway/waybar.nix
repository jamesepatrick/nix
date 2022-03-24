{ options, config, lib, pkgs, ... }:
let
  cfg = config.this.application.waybar;
  sway_cfg = config.this.application.sway;
in with lib; {
  options = {
    this.application.waybar.enable = mkOption {
      default = sway_cfg.enable;
      type = with types; bool;
      description = "testing one two three";
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.james = { home.packages = with pkgs; [ waybar ]; };
  };
}
