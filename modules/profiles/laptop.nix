{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ ./graphical.nix ];

  networking.networkmanager.enable = true;
  users.users.james.extraGroups = [ "networkmanager" ];
}
