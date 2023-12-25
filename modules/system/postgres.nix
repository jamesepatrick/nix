{ config, lib, pkgs, user, ... }:
let this = config.my.system.postgres;
in with lib; {
  options.my.system.postgres.enable = mkEnableOption "Postgres Server";

  config = mkIf this.enable {
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_14;
      enableTCPIP = true;
      ensureDatabases = [ "${user.name}" ];
      ensureUsers = [{ name = "${user.name}"; }];
      authentication = pkgs.lib.mkOverride 14 ''
        local all all trust
        host all all 127.0.0.1/32 trust
        host all all ::1/128 trust
      '';
    };
  };
}
