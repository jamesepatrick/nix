{ config, lib, pkgs, ... }: {
  imports = [ ./graphical.nix ];
  my.system.boot.enable = true;
  networking.networkmanager.enable = true;
  users.users.james.extraGroups = [ "networkmanager" ];
}
