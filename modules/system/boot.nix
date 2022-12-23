{ config, lib, pkgs, ... }:
let this = config.my.system.boot;
in
with lib; {
  options.my.system.boot.enable = mkOption {
    default = true;
    type = with types; bool;
    description = "Is there a physical power button?";
  };

  config = mkIf this.enable {
    boot = {
      # Enable bootloader & clear /tmp on boot.
      cleanTmpDir = true;
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      # Enable plymouth
      plymouth = {
        enable = true;
        themePackages = [ pkgs.plymouth-themes ];
        theme = "connect";
      };
      initrd.systemd.enable = true;
    };
  };
}
