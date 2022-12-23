{ config, lib, pkgs, user, ... }:
let
  this = config.my.application.mqtt;
  graphical = config.my.graphical;
in
with lib; {
  options = {
    my.application.mqtt.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    home-manager.users."${user.name}".home.packages = with pkgs; [
      mqttui
    ];
  };
}
