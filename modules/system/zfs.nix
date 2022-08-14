{ config, lib, pkgs, ... }:
let cfg = config.my.system.zfs;
in with lib; {
  options.my.system.zfs.enable = mkEnableOption "zfs";

  config = mkIf cfg.enable {
    boot = {
      supportedFilesystems = [ "zfs" ];
      zfs = {
        forceImportRoot = false;
        forceImportAll = false;
      };
      # this was required for the initial setup of the zpool.
      # see https://nixos.org/nixos/options.html#boot.zfs.forceimportroot
      # kernelParams = ["zfs_force=1"];
    };

    services.zfs = {
      autoScrub.enable = true;
      # enable default auto-snapshots
      autoSnapshot = {
        enable = true;
        flags = "-k -p --utc";
      };
    };
  };
}
