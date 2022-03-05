{ config, pkgs, ... }: {
  imports = [ ./golang.nix ./javascript.nix ./bash.nix ];
}
