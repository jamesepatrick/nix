{ config, pkgs, lib, ... }: {
  options.this.graphical.enable = lib.mkOption {
    default = false;
    type = with lib.types; bool;
    description = "Does this actually need X/Wayland";
  };

  options.this.graphical.protocol = mkOption {
    type = types.enum [ "X11" "Wayland" ];
    default = null;
  };

  imports = [ ./applications ./lang ./system ];
}
