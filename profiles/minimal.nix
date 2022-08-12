{ config, pkgs, ... }:

let
  publicKey = pkgs.fetchurl {
    url = "https://github.com/jamesepatrick.keys";
    sha256 = "sha256-alm6KRFca4VjzTyVEg+j1s0uKaSfvV76o3sgYNAisSA=";
  };
in {

  imports = [
    ../modules/. # This imports /modules/default.nix
    ../modules/system/xdg.nix
  ];
  # Allow Cleanup, nix, & flakes
  nix = {
    settings = {
      auto-optimise-store = true;
      allowed-users = [ "@wheel" ];
    };
    gc = {
      automatic = true;
      dates = "daily";
    };
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config.allowUnfree = true;

  # Locale
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    root.initialPassword = "nixos";
    james = {
      description = "James Patrick";
      extraGroups = [ "wheel" "systemd-journal" ];
      initialPassword = "nixos";
      isNormalUser = true;
      openssh.authorizedKeys.keyFiles = [ publicKey ];
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

  # Openssh settings for security
  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
  };
}
