{ config, pkgs, lib, ... }: {
  options.this.graphical.enable = lib.mkOption {
    default = false;
    type = with lib.types; bool;
    description = "Does this actually need X/Wayland";
  };

  imports = [
    ./system
    ./applications
    # TODO Refactor everything after this.
    ./cli.nix
  ];
}
