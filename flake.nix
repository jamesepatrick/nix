{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/v1.3.1";
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

  outputs =
    inputs@{ self
    , emacs-overlay
    , home-manager
    , nixos-hardware
    , nixpkgs
    , nur
    , utils
    , ...
    }:
    let
      inherit (utils.lib) mkFlake;
      inherit (self.lib.my) mapModules mapModulesRec';
    in
    mkFlake {
      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib {
          inherit inputs;
          pkgs = nixpkgs;
          lib = self;
        };
      });

      inherit self inputs;
      supportedSystems = [ "x86_64-linux" ];
      hosts = {
        nil.modules = [
          nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen2
          ./hosts/nil
        ];
      };

      channels.nixpkgs = {
        input = nixpkgs;
        overlaysBuilder = channels: [ ];
      };
      channelsConfig = { allowUnfree = true; };

      sharedOverlays = [ nur.overlay emacs-overlay.overlay ];
      hostDefaults = {
        modules = mapModulesRec' ./modules import ++ [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.james = import ./home.nix;
          }
          { nixpkgs.overlays = [ nur.overlay (import ./pkgs) ]; }
        ];
        system = "x86_64-linux";
      };
    };
}
