{ config, pkgs, lib, ... }: {

  options.my.graphical = {
    enable = lib.mkEnableOption "Does this actually need X/Wayland";
  };
}
