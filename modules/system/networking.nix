{ config, lib, pkgs, ... }: {
  programs.mtr.enable = true;
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 443 80 ];
      allowedUDPPorts = [ 443 80 ];
      allowPing = false;
    };
  };
}
