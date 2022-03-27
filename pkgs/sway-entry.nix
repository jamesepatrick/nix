{ pkgs, ... }:
let
in pkgs.writeShellScriptBin "sway-entry" ''
  #! ${pkgs.bash}/bin/bash

  # first import environment variables from the login manager
  # function is currently deprecated. It should be rolled back in the future
  systemctl --user import-environment

  # then start the service
  exec systemctl --user start sway.service
''
