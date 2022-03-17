{ pkgs, ... }:
let
in pkgs.writeShellScriptBin "brightness.sh" ''
  #! ${pkgs.bash}/bin/bash
  function notify {
    val="$(light | cut -d '.' -f 1)"
    str="$val     $(seq -s "▒" "$(($val / 5 ))" | sed 's/[0-9]//g' )"
    icon=/etc/profiles/per-user/james/share/icons/kora/actions/16/contrast.svg
    echo "$str"
    notify-send "$str" -h string:x-canonical-private-synchronous:brightness -i $icon -t 1500
  }

  case $1 in
    up)
      ${pkgs.light}/bin/light -A 5 ; notify ;;
    down)
      ${pkgs.light}/bin/light -U 5 ; notify ;;
    *)
      echo "invalid command"
      ;;
  esac
''
