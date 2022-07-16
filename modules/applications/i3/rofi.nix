{ config, lib, pkgs, ... }:
let
  cfg = config.this.application.i3.rofi;
  i3 = config.this.application.i3;

in with lib; {
  options = {
    this.application.i3.rofi.enable = mkOption {
      default = i3.enable;
      type = with types; bool;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.james = {
      home.packages = with pkgs; [ rofi-systemd rofi-power-menu ];
      programs.rofi = {
        enable = true;
        package =
          pkgs.rofi.override { plugins = with pkgs; [ rofi-emoji rofi-calc ]; };
      };
    };
  };
}
