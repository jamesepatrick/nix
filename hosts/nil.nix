# This is nil.
# Nil is my current personal machine. It is a AMD Thinkpad T14 G2 with the follow specs;
#
# Onboard Memory: 16 GB DDR4 3200MHz (Soldered) Note: This can support another stick of RAM.
# Wireless: Realtek 8852AE 802.11AX (2 x 2) & Bluetooth® 5.2
# Processor: AMD Ryzen™ 5 Pro 5650U Processor (2.30 GHz, up to 4.20 GHz Max Boost, 6 Cores, 12 Threads, 16 MB Cache)
# Graphic Card: Integrated AMD Radeon™ Graphics
# Battery: 3 Cell Li-Polymer 50Wh
# Camera: IR & 720p HD
# SSD: 128 GB PCIe SSD
# Keyboard: US English
# System Expansion Slots: Smart Card Reader
# TPM Setting: Enabled Discrete TPM2.0
# Display: 14.0" FHD (1920 x 1080) IPS, anti-glare, touchscreen with Privacy Guard, 500 nits
#
# Its formatted as follows
# NAME                          TYPE     MOUNTPOINT
# nvme0n1                       disk
# ├─nvme0n1p1                   part     /boot
# └─nvme0n1p2                   part
#   └─crypt                     crypt    /dev/mapper/root
#     └─partitions              lvm
#       ├─swap                  swap     /dev/partitions/swap
#       └─lvm_root              lvm      /dev/partitions/lvm_root
#         └─rpool               zpool
#           ├─rpool/root        zfs
#           ├─rpool/root/nixos  zfs      /
#           └─rpool/home        zfs      /home
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ../modules/profiles/laptop.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  this.systems.zfs.enable = true;

  networking = {
    # This is required for the zfs module as well. Must be unique. Run the following head -c4  /dev/urandom | od -A none -t x4
    hostId = "a7a1c3f5";
    hostName = "nil"; # Define your hostname.

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces = {
      enp2s0f0.useDHCP = true;
      enp5s0.useDHCP = true;
      wlp3s0.useDHCP = true;
    };
  };

  hardware.firmware = [ pkgs.rtw89-firmware ];

  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "vfat"
        "xhci_pci"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "sdhci_pci"
        "cryptd"
      ];
      kernelModules = [ "dm-snapshot" ];
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ config.boot.kernelPackages.rtw89 ];
    supportedFilesystems = [ "zfs" ];
  };

  boot.initrd.luks.devices."crypt" = {
    device = "/dev/disk/by-partlabel/crypt";
    preLVM = true;
  };

  fileSystems = {
    "/" = {
      device = "rpool/root/nixos";
      fsType = "zfs";
    };
    "/home" = {
      device = "rpool/home";
      fsType = "zfs";
    };
    "/boot" = {
      device = "/dev/disk/by-partlabel/boot";
      fsType = "vfat";
    };
  };

  swapDevices = [{ device = "/dev/partitions/swap"; }];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
