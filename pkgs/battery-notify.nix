{ pkgs, ... }:
let
  xpub = pkgs.fetchurl {
    url =
      "https://raw.githubusercontent.com/Ventto/xpub/f2eadaaf9c8539abbd46b23c0b2f6d93d2ebd658/src/xpub.sh";
    sha256 = "sha256-88t9lr6DxrWrg6E4YsWGzYV9/GbRgwLafAklXHObqsI=";
    executable = true;
  };
in pkgs.writeShellScriptBin "battery-notify" ''
  #!${pkgs.bash}/bin/bash

  # ''${DISPLAY:=":0"}
  #: $\{XUSER:=":james"\}

  touch /tmp/battery-notify
  echo "display:$DISPLAY" >> /tmp/battery-notify
  echo "tty:$TTY" >> /tmp/battery-notify
  echo "XUSER:$XUSER" >> /tmp/battery-notify
  echo "DBUS_SESSION_BUS_ADDRESS:$DBUS_SESSION_BUS_ADDRESS" >> /tmp/battery-notify

  export $(${xpub}) ;
  function last_chance {
      if [ -f /tmp/last_chance ] ; then
          echo "There already exist another processing doing this. Aborting."
          exit
      else
          ${pkgs.coreutils}/bin/touch /tmp/last_chance
      fi

      countdown=30
      while [[ $(${pkgs.coreutils}/bin/cat /sys/class/power_supply/AC/online) -eq 0 ]] ; do
          if [[ countdown -gt 0 ]] ; then
              ${pkgs.libnotify}/bin/notify-send -h string:x-canonical-private-synchronous:battery -u critical " Critical Battery - Suspension imminent." "You have $countdown seconds." ; sleep 1
              let "countdown=countdown-1"
          else
              ${pkgs.libnotify}/bin/notify-send -h string:x-canonical-private-synchronous:battery -u low " Critical Battery" "PlaceHolder"
              break;
          fi
      done

      ${pkgs.coreutils}/bin/rm /tmp/last_chance
  }

  case $1 in
      charging)
          ${pkgs.libnotify}/bin/notify-send -h string:x-canonical-private-synchronous:battery -u low " Power Connected" "Battery at $(${pkgs.coreutils}/bin/cat /sys/class/power_supply/BAT0/capacity)%";;
      discharging)
          ${pkgs.libnotify}/bin/notify-send -h string:x-canonical-private-synchronous:battery -u low " Power Disconnected" "Battery at $(${pkgs.coreutils}/bin/cat /sys/class/power_supply/BAT0/capacity)%";;
      warn)
          ${pkgs.libnotify}/bin/notify-send -h string:x-canonical-private-synchronous:battery -u normal " Discharging" "Battery at $(${pkgs.coreutils}/bin/cat /sys/class/power_supply/BAT0/capacity)%";;
      danger)
          ${pkgs.libnotify}/bin/notify-send -h string:x-canonical-private-synchronous:battery -u critical " Low Battery" "Battery at $(${pkgs.coreutils}/bin/cat /sys/class/power_supply/BAT0/capacity)%. Will suspend soon.";;
      ohfuck)
          last_chance ;;
      *)
            echo "invalid command" ;;
  esac
''
