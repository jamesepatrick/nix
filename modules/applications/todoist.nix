{ config, lib, pkgs, user, ... }:
let
  this = config.my.application.todoist;
  graphical = config.my.graphical;
in
with lib; {
  options = {
    my.application.todoist.enable = mkOption {
      default = graphical.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    home-manager.users."${user.name}".home.packages = with pkgs; [
      elementary-planner
      todoist
      todoist-electron
    ];
  };
}
