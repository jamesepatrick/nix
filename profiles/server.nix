{ config, lib, pkgs, ... }: {
  imports = [ ./minimal.nix ];

  my = { system.power.enable = true; };
}
