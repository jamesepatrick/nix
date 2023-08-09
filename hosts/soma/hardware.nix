{ self, config, nixos-hardware, lib, pkgs, modulesPath, ... }: {
  imports = [ nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen2 ];

  my.system.btrfs.enable = true;
  networking = {
    hostName = "soma";
    useDHCP = false;
    interfaces = {
      enp2s0.useDHCP = true;
      enp0s31f6.useDHCP = false;
    };
  };

  boot = {
    initrd = {
      availableKernelModules = [
        "ahci" # don't wrap
        "nvme"
        "sd_mod"
        "sr_mod"
        "usb_storage"
        "usbhid"
        "xhci_pci"
      ];
      kernelModules = [ "dm-snapshot" ];
    };
    kernelModules = [ "kvm-intel" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/root";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
    "/mnt/tv" = {
      device = "/dev/disk/by-label/tv";
      fsType = "ext4";
    };
    "/mnt/movies" = {
      device = "/dev/disk/by-label/movies";
      fsType = "ext4";
    };
    "/mnt/misc" = {
      device = "/dev/disk/by-label/misc";
      fsType = "ext4";
    };
    "/mnt/cache" = {
      device = "/dev/disk/by-label/cache";
      fsType = "btrfs";
    };
  };
  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
