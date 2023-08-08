{ config, lib, pkgs, user, ... }: {
  imports = [ ./graphical.nix ];
  my.system.boot.enable = true;
  services.fwupd.enable = true;

  # fan control modules
  boot.extraModprobeConfig = ''
    options thinkpad_acpi fan_control=1 experimental=1
  '';

  environment.systemPackages = with pkgs; [ tpacpi-bat ];
}
