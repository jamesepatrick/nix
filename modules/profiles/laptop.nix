{ config, lib, pkgs, ... }: {
  imports = [ ./graphical.nix ];

  this.systems.boot.enable = true;
  networking.networkmanager.enable = true;
  users.users.james.extraGroups = [ "networkmanager" ];
}
