self: super: {
  brightness-sh = super.callPackage ./brightness.nix { inherit super; };
  battery-notify = super.callPackage ./battery-notify.nix { inherit super; };
  schubsigo = super.callPackage ./schubsigo { inherit super; };
  volume-sh = super.callPackage ./volume.nix { inherit super; };
}
