# Define a user account. Don't forget to set a password with ‘passwd’.
{ config, lib, pkgs, ... }: {
  users.users = {
    root.initialPassword = "noreallychangemenow";
    james = {
      description = "James Patrick";
      extraGroups = [ "wheel" "systemd-journal" ];
      initialPassword = "nixos";
      isNormalUser = true;
      shell = pkgs.zsh;
    };
  };
}
