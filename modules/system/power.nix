{ config, lib, pkgs, ... }:
let cfg = config.this.system.power;
in with lib; {
  options.this.system.power.enable = mkEnableOption "Power Management";

  config = mkIf cfg.enable {
    # fan control modules
    boot.extraModprobeConfig = ''
      options thinkpad_acpi fan_control=1 experimental=1
    '';

    # battery optimizations
    powerManagement.powertop.enable = true;
    services.upower.enable = true;

    environment.systemPackages = with pkgs; [ powertop tpacpi-bat ];
  };
}
