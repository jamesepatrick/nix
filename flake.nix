{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/v1.3.0";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, utils, nixpkgs, nixos-hardware, nur, home-manager
    , emacs-overlay, ... }:
    utils.lib.mkFlake {
      hosts = {
        nil.modules = [
          nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
          ./hosts/nil.nix
        ];
      };

      # Shared logic below.
      inherit self inputs;
      supportedSystems = [ "x86_64-linux" ];
      channels.nixpkgs = {
        input = nixpkgs;
        overlaysBuilder = channels: [ ];
      };
      channelsConfig = { allowUnfree = true; };
      sharedOverlays = [ nur.overlay emacs-overlay.overlay ];
      hostDefaults = {
        modules = [
          nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
          ./hosts/nil.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.james = import ./home.nix;
          }
          { nixpkgs.overlays = [ nur.overlay ]; }
        ];
        system = "x86_64-linux";
      };

    };
}
