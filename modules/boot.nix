{ config, lib, ... }: {
  boot = {
    # Enable bootloader & clear /tmp on boot.
    cleanTmpDir = true;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
