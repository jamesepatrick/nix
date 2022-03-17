{ pkgs, ... }:
let
in pkgs.writeShellScriptBin "volume.sh" ''
  #! ${pkgs.bash}/bin/bash
  function get_volume {
    amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
    }

  function is_mute {
    amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
  }

  function notify {
    vol=$(get_volume)
    str="$vol     $(seq -s "▒" "$(($vol / 5 ))" | sed 's/[0-9]//g' )"
    if is_mute ; then
      icon=/etc/profiles/per-user/james/share/icons/kora/actions/16/audio-volume-muted.svg
    else
      if (( "$vol" == "0" ))  ; then
        icon=/etc/profiles/per-user/james/share/icons/kora/actions/16/audio-volume-off.svg
      elif (( "$vol" < "30"  )) ; then
        icon=/etc/profiles/per-user/james/share/icons/kora/actions/16/audio-volume-low.svg
      elif (( "$vol" < "60"  )) ; then
        icon=/etc/profiles/per-user/james/share/icons/kora/actions/16/audio-volume-medium.svg
      else
        icon=/etc/profiles/per-user/james/share/icons/kora/actions/16/audio-volume-high.svg
      fi
    fi
    echo "$str"
    notify-send "$str" -h string:x-canonical-private-synchronous:volume -i $icon -t 1500
  }

  case $1 in
    up)
      pactl set-sink-volume @DEFAULT_SINK@ +5% ; notify ;;
    down)
      pactl set-sink-volume @DEFAULT_SINK@ -5% ; notify ;;
    mute)
      amixer set Master toggle > /dev/null ; notify ;;
    *)
      echo "invalid command"
      ;;
  esac
  $(is_mute) ; echo $?
''
