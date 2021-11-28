{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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
  };

  # All outputs for the system (configs)
  outputs = { home-manager, nixpkgs, nur, nixos-hardware, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {allowUnfree = true;};
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        # Config is based on hostname
        nil = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
            ./hosts/nil.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.james = import ./home.nix;
            }
          ];
        };

      };
    };
}
