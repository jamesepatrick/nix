{
  description = "NixOS configuration";
  inputs = {
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    scalpel = {
      url = "github:polygon/scalpel";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        sops-nix.follows = "sops-nix";
      };
    };
    sops-nix.url = "github:Mic92/sops-nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/v1.3.1";
  };

  outputs = inputs@{ self, emacs-overlay, home-manager, nixos-hardware, nixpkgs
    , nur, sops-nix, utils, ... }:
    let
      inherit (utils.lib) mkFlake;
      inherit (self.lib.my) mapModules mapModulesRec';
    in mkFlake {
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
        nil.modules = [ ./hosts/nil ];
        soma.modules = [ ./hosts/soma ];
      };
      channels.nixpkgs = {
        input = nixpkgs;
        overlaysBuilder = channels: [ ];
      };
      channelsConfig = { allowUnfree = true; };
      sharedOverlays = [ nur.overlay (import ./pkgs) emacs-overlay.overlay ];
      hostDefaults = {
        specialArgs = {
          inherit home-manager nixos-hardware;
          user = {
            name = "james";
            description = "James Patrick";
          };
        };
        modules = mapModulesRec' ./modules import
          ++ [ sops-nix.nixosModules.sops ];
        system = "x86_64-linux";
      };
    };
}
