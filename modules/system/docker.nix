{ config, lib, pkgs, user, ... }:
let
  this = config.system.docker;
in
with lib; {
  options = {
    system.docker.enable = mkOption {
      default = true;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    virtualisation.docker = {
      enable = true;
      autoPrune.enable = true;
    };

    users.users."${user.name}".extraGroups = [ "docker" ];

    # This is the old version of docker-compose. run "docker compose" for the v2 implementation.
    environment.systemPackages = with pkgs; [ docker-compose ];
  };
}
