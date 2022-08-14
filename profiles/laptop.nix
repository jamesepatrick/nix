{ config, lib, pkgs, user, ... }: {
  imports = [ ./graphical.nix ];
  my.system.boot.enable = true;
  networking.networkmanager.enable = true;
  users.users."${user.name}".extraGroups = [ "networkmanager" ];
}
