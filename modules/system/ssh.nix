{ config, lib, pkgs, user, ... }:
#with lib.my;
with lib;
let
  this = config.my.system.ssh;
  publicKey = pkgs.fetchurl {
    url = "https://github.com/jamesepatrick.keys";
    sha256 = "sha256-VGdWnlzD11L8fjoN/etmV50nHr5xrIP91BGV7x0Otks=";
  };
in {
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
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    users.users."${user.name}".openssh.authorizedKeys.keyFiles = [ publicKey ];
  };
}
