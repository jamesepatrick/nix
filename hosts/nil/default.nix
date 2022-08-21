# This is nil.
# Nil is my currently my primary personal machine. It is a AMD Thinkpad T14 G2.
# Specs can be can be found in hardware.nix

{ self, config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ./hardware.nix
    ../../profiles/laptop.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  my.system = {
    fprint.enable = true;
    yubikey.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
