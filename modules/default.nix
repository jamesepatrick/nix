{ config, pkgs, lib, ... }: {
  options = {
    graphical = {
      enable = lib.mkOption {
        default = false;
        type = with lib.types; bool;
        description = "Does this actually need X/Wayland";
      };
    };
  };

  imports = [
    ./system
    ./applications
    # TODO Refactor everything after this.
    ./boot.nix
    ./cli.nix
    ./fonts.nix
    ./zfs.nix
  ];
}
