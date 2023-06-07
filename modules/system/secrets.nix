{ config, lib, pkgs, user, ... }:
let this = config.my.system.secrets;
in with lib; {
  options.my = {
    secrets = {
      email = {
        primary = mkOption { default = "email@example.com"; };
        aliases = mkOption { default = [ ]; };
      };
    };
    system.secrets.enable = mkOption {
      default = false;
      type = with types; bool;
    };
  };

  config = mkIf this.enable ({
    environment.systemPackages = with pkgs; [ git-crypt ];
  });
}
