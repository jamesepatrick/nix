# Define a user account. Don't forget to set a password with ‘passwd’.
{ config, lib, pkgs, user, ... }: {
  users.users = {
    root.initialPassword = "noreallychangemenow";

    "${user.name}" = {
      description = "${user.description}";
      extraGroups = [ "wheel" "systemd-journal" ];
      initialPassword = "nixos";
      isNormalUser = true;
      shell = pkgs.zsh;
    };
  };

  home-manager.users."${user.name}".home = {
    username = "${user.name}";
    homeDirectory = "/home/${user.name}";
  };
}
