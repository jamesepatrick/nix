{ inputs, config, pkgs, ... }:

let
in {

  imports = [
    #../modules/. # This imports /modules/default.nix
    #../modules/system/xdg.nix
  ];
  # These are the most basic tools I need.
  environment.systemPackages = with pkgs; [ nixfmt git gnumake vim zsh ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

}
