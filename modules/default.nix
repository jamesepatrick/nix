{ config, pkgs, lib, ... }:
with lib;
let
in {

  options.this.graphical.enable =
    mkEnableOption "Does this actually need X/Wayland";

  options.this.graphical.protocol = mkOption {
    type = types.enum [ "X11" "Wayland" ];
    default = null;
  };

  imports = [ ./applications ./lang ./system ];
}
