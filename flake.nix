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
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/v1.5.1";
  };

  outputs = inputs@{ self, emacs-overlay, home-manager, nixos-hardware, nixpkgs
    , nur, utils, ... }:
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
        modules = mapModulesRec' ./modules import;
        system = "x86_64-linux";
      };
    };
}
