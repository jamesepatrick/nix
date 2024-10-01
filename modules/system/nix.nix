{ config, lib, pkgs, ... }: {
  nix = {
    settings = {
      auto-optimise-store = true;
      allowed-users = [ "@wheel" ];
    };
    gc = {
      automatic = true;
      dates = "daily";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    package = pkgs.nixVersions.latest;
  };
}
