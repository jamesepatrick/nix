# Build Specs
# ###############################################################################
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
{ self, config, nixos-hardware, lib, pkgs, modulesPath, ... }: {
  imports = [ nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen2 ];
  my.system = {
    zfs.enable = true;
    yubikey.enable = true;
    fprint.enable = true;
  };

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

  # error: rtw89-firmware has been removed because linux-firmware now contains it
  #hardware.firmware = [ pkgs.rtw89-firmware ];

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
      luks.devices."crypt" = {
        device = "/dev/disk/by-partlabel/crypt";
        preLVM = true;
      };
    };
    kernelModules = [ "kvm-amd" ];
    # Need for https://github.com/NixOS/nixpkgs/issues/177844
    # Currently zfs-kernel is broken for latest & LTS is broken due to kernel
    # issues with the rtw89 firmware. The current work around is to ignore the
    # broken argument.
    kernelPackages = pkgs.linuxPackages_latest.extend (final: prev: {
      zfs = prev.zfs.overrideAttrs (_: { meta.broken = false; });
    });
    supportedFilesystems = [ "zfs" ];
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
}
