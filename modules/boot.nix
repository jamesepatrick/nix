{ config, lib, ... }: {
  # Enable bootloader & clear /tmp on boot.
  boot = {
    cleanTmpDir = true;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
