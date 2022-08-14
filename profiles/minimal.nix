{ inputs, config, pkgs, ... }:

let
in {

  imports = [
    #../modules/. # This imports /modules/default.nix
    #../modules/system/xdg.nix
  ];
  # Allow Cleanup, nix, & flakes

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    root.initialPassword = "nixos";
    james = {
      description = "James Patrick";
      extraGroups = [ "wheel" "systemd-journal" ];
      initialPassword = "nixos";
      isNormalUser = true;
      shell = pkgs.zsh;
    };
  };

  # These are the most basic tools I need.
  environment.systemPackages = with pkgs; [ nixfmt git gnumake vim zsh ];

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 443 80 ];
      allowedUDPPorts = [ 443 80 ];
      allowPing = false;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

}
