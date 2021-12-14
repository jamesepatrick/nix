{ options, config, lib, pkgs, ... }:
let
  cfg = config.application.waybar;
  sway_cfg = config.application.sway;
in with lib; {
  options = {
    application.waybar = {
      enable = mkOption {
        # TODO track based on sway default
        default = sway_cfg.enable;
        type = with types; bool;
        description = "testing one two three";
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.james = { home.packages = with pkgs; [ waybar ]; };
  };
}
