{ config, pkgs, ... }:

let
  publicKey = pkgs.fetchurl {
    url = "https://github.com/jamesepatrick.keys";
    sha256 = "sha256-Btjo+v/xA26CwwFauNmSdJOauIq/yZoBV1Com39nu6E=";
  };
in {
  # Allow Cleanup, nix, & flakes
  nix = {
    autoOptimiseStore = true;
    allowedUsers = [ "@wheel" ];
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
      extraGroups = [ "wheel" ];
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