{ self, config, nixos-hardware, lib, pkgs, modulesPath, ... }: {
  imports = [ ../../secrets/common.nix ];
  my.system = {
    postgres.enable = true;
    secrets.enable = true;
  };
}
