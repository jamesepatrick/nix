{ config, lib, pkgs, ... }:
let this = config.my.system.power;
in with lib; {
  options.my.system.power.enable = mkEnableOption "Power Management";

  config = mkIf this.enable {

    # battery optimizations
    powerManagement = {
      powertop.enable = true;
      cpuFreqGovernor = lib.mkDefault "powersave";
    };

    services.upower.enable = true;

    environment.systemPackages = with pkgs; [ poweralertd powertop ];
  };
}
