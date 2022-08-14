{ config, lib, pkgs, user, ... }:
#with lib.my;
with lib;
let
  this = config.my.system.ssh;
  publicKey = pkgs.fetchurl {
    url = "https://github.com/jamesepatrick.keys";
    sha256 = "sha256-alm6KRFca4VjzTyVEg+j1s0uKaSfvV76o3sgYNAisSA=";
  };
in
{
  options.my = {
    system.ssh.enable = mkOption {
      default = true;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    # Openssh settings for security
    services.openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
    };

    users.users."${user.name}".openssh.authorizedKeys.keyFiles = [ publicKey ];
  };
}
