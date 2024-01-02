{ config, lib, pkgs, user, ... }:
let this = config.system.networking;
in with lib; {
  options = {
    system.networking = {
      enable = mkOption {
        default = true;
        type = with types; bool;
      };
      allowedPorts = mkOption {
        default = with pkgs; [ 443 80 ];
        type = with types; listOf port;
        description =
          "List of ports that can be opened. Applies to both UDP and TCP";
      };
    };
  };

  config = mkIf this.enable {
    networking.networkmanager.enable = true;
    users.users."${user.name}".extraGroups = [ "networkmanager" ];
    programs.mtr.enable = true;
    networking = {
      firewall = {
        enable = true;
        allowedTCPPorts = this.allowedPorts;
        allowedUDPPorts = this.allowedPorts;
        allowPing = false;
      };
    };
  };
}
