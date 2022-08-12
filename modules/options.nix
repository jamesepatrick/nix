{ config, pkgs, lib, ... }: {

  options.this.graphical = {
    enable = lib.mkEnableOption "Does this actually need X/Wayland";
  };

  #  imports = [ ./applications ./lang ./system ];
}
