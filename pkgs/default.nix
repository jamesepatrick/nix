self: super: {
  battery-notify = super.callPackage ./battery-notify.nix { inherit super; };
  brightness-sh = super.callPackage ./brightness.nix { inherit super; };
  plymouth-themes = super.callPackage ./plymouth-themes.nix { inherit super; };
  schubsigo = super.callPackage ./schubsigo { inherit super; };
  volume-sh = super.callPackage ./volume.nix { inherit super; };
}
