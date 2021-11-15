# /etc/nixos/zfs.nix (Don't forget to add it to configuration.nix)
# These are the options ZFS requires, but a normal system has, of course,
#   more options (like a bootloader, or installed software).
{ config, pkgs, ... }:
{
  # remove this after 1st boot
  # see https://nixos.org/nixos/options.html#boot.zfs.forceimportroot
  boot.kernelParams = ["zfs_force=1"];

  boot.zfs.forceImportRoot = false;
  boot.zfs.forceImportAll = false;

  boot.supportedFilesystems = [ "zfs" ];

  services.zfs.autoScrub.enable = true;
  # this enables the zfs-auto-snapshot
  services.zfs.autoSnapshot = {
    enable = true;
    flags = "-k -p --utc";
  };
}
