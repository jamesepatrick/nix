self: super: {
  brightness-sh = super.callPackage ./brightness.nix { inherit super; };
  plymouth-themes = super.callPackage ./plymouth-themes.nix { inherit super; };
  schubsigo = super.callPackage ./schubsigo.nix { inherit super; };
  volume-sh = super.callPackage ./volume.nix { inherit super; };
}
