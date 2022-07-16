{ config, lib, pkgs, ... }:
let cfg = config.this.system.boot;
in with lib; {
  options.this.system.boot.enable = mkOption {
    default = true;
    type = with types; bool;
    description = "Is there a physical power button?";
  };

  config = mkIf cfg.enable {
    boot = {
      # Enable bootloader & clear /tmp on boot.
      cleanTmpDir = true;
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };
  };
}
