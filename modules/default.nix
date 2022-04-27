{ config, pkgs, lib, ... }:
with lib;
let
in {

  options.this.graphical = {
    enable = mkEnableOption "Does this actually need X/Wayland";
  };

  imports = [ ./applications ./lang ./system ];
}
