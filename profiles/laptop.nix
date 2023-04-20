{ config, lib, pkgs, user, ... }: {
  imports = [ ./graphical.nix ];
  my.system.boot.enable = true;
  services.fwupd.enable = true;
}
