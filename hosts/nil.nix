# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ../modules/zfs.nix
    ../modules/profiles/laptop.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # This is required for the zfs module as well. Must be unique. Run the following
  #   head -c4  /dev/urandom | od -A none -t x4
  networking.hostId = "a7a1c3f5";
  networking.hostName = "nil"; # Define your hostname.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp2s0f0.useDHCP = true;
  networking.interfaces.enp5s0.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  boot.initrd.availableKernelModules = [
    "nvme"
    "vfat"
    "xhci_pci"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "sdhci_pci"
    "cryptd"
  ];

  hardware.firmware = [ pkgs.rtw89-firmware ];

  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.rtw89 ];
  boot.supportedFilesystems = [ "zfs" ];

  boot.initrd.luks.devices."crypt" = {
    device = "/dev/disk/by-partlabel/crypt";
    preLVM = true;
  };

  fileSystems."/" = {
    device = "rpool/root/nixos";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "rpool/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/boot";
    fsType = "vfat";
  };

  swapDevices = [{ device = "/dev/partitions/swap"; }];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
