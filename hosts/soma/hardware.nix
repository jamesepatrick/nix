# Build Specs
# ###############################################################################
# Motherboard: MSI H170M ECO
# CPU: Intel Pentium G4400
# Memory: 16GB (2 x 8GB) G.SKILL Ripjaws V Series F4-2133C15D-16GVR
# PowerSupply: EVGA SuperNOVA 650 G1 120-G1-0650-XR 80+ GOLD 650W
# Case: Rosewill 4U RSV-R4000U
# NIC: TP-Link TG-3468 :: 10/100/1000Mbps Gigabit Ethernet PCI Express Network Card
#
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

  # Storage
  # DEVICE     SIZE    MAKE       MODEL                    SERIAL            NOTES
  # sda        512G    Samsung    MZMTE512HMHP-000MV       S1F2NYAF100039
  # sdb        4T      WDC        WD40EFRX-68WT0N0         WD-WCC4E4RD9LK4
  # sdc        4T      WDC        WD40EFRX-68WT0N0         WD-WCC4E4RD99PY
  # sdd        4T      WDC        WD40EFRX-68WT0N0         WD-WCC7K1XHVEFZ
  # sde        16T     WDC        WDC_WD160EDGZ-11B2DA0    2BJH34AN
  # nvme0n1    1T      Samsung    SSD_970_EVO_1TB          S5H9NC0MC28429W
  #
  # NAME         TYPE     LABEL     SIZE     MOUNTPOINT
  # sda
  # ├── sda1     vfat     boot      512M     /boot
  # ├── sda2     ext4     root      459G     /
  # └── sda3     swap     swap      17G
  # sdb
  # ├── sdb1     btrfs    movies    3.2T     /mnt/movies
  # └── sdb2     ????     raid      500G      ?????
  # sdc
  # ├── sdc1     btrfs    misc      3.2T     /mnt/misc
  # └── sdc2     ????     raid      500G      ?????
  # sdd
  # └── sdd1     btrfs    tv_old    3.6T
  # sde
  # └── sde1     btrfs    tv        14.6T    /mnt/tv
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
      fsType = "btrfs";
    };
    "/mnt/movies" = {
      device = "/dev/disk/by-label/movies";
      fsType = "btrfs";
    };
    "/mnt/misc" = {
      device = "/dev/disk/by-label/misc";
      fsType = "btrfs";
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
