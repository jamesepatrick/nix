{ options, config, lib, pkgs, user, ... }:
let
  this = config.my.application.dunst;
  i3 = config.my.application.i3;
  graphical = config.my.graphical;
in
with lib; {
  options = {
    my.application.dunst.enable = mkOption {
      default = i3.enable;
      type = with types; bool;
    };
  };

  config = mkIf this.enable {
    home-manager.users."${user.name}" = {
      systemd.user.startServices = true;
      services.dunst.enable = true;
      home.packages = with pkgs; [ libnotify ];

      xdg.configFile."dunst/dunstrc".text = ''
        [global]
          monitor = 0
          follow = mouse
          shrink = no
          padding = 20
          horizontal_padding = 20

          width = 350
          height = 100
          offset = 20x20
          origin = top-right

          frame_width = 0
          separator_height = 0
          frame_color = "#161720ee"
          separator_color = "#12151a"

          sort = no
          font = Overpass 10.5
          markup = full
          format = "<b>%s</b>\n%b"
          alignment = left
          show_age_threshold = 60
          word_wrap = yes
          ignore_newline = no
          stack_duplicates = true
          hide_duplicate_count = no
          show_indicators = yes

          icon_position = left
          max_icon_size= 60
          sticky_history = no
          history_length = 6
          title = Dunst
          class = Dunst
          corner_radius = 3

          mouse_left_click = close_current
          mouse_middle_click = do_action
          mouse_right_click = close_all

        [urgency_low]
          background = "#161720ee"
          foreground = "#f5c2e7"
          timeout = 5

        [urgency_normal]
          background = "161720ee"
          foreground = "#f5c2e7"
          timeout = 10

        [urgency_critical]
          background = "161720ee"
          foreground = "#f5c2e7"
          timeout = 20
      '';

    };

    systemd.user.services.dunst = {
      enable = true;
      description = "Notifications ";
      wantedBy = [ "i3-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.dunst}/bin/dunst";
        RestartSec = 5;
        Restart = "always";
      };
    };
  };
}
