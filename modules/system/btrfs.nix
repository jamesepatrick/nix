{ config, lib, pkgs, ... }:
let this = config.my.system.btrfs;
in with lib; {
  options.my.system.btrfs.enable = mkEnableOption "btrfs";

  config = mkIf this.enable {
    services.btrfs.autoScrub.enable = true;
    environment.systemPackages = with pkgs; [ btrfs-progs compsize dduper ];
  };
}
