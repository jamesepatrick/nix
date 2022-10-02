{ self, config, nixos-hardware, lib, pkgs, modulesPath, ... }: {
  my.system = {
    postgres.enable = true;
  };
}
