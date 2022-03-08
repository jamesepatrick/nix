{ options, config, lib, pkgs, ... }:
let
  cfg = config.this.application.dunst;
  sway = config.this.application.sway;
in with lib; {
  options = {
    this.application.dunst = {
      enable = mkOption {
        default = sway.enable;
        type = with types; bool;
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.james = {
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

          width = 275
          height = 100
          offset = 40x60
          origin = top-right

          frame_width = 0
          separator_height = 0
          frame_color = "#151515"
          separator_color = "#151515"

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
          background = "#1a1826"
          foreground = "#f5c2e7"
          timeout = 5

        [urgency_normal]
          background = "#1a1826"
          foreground = "#f5c2e7"
          timeout = 10

        [urgency_critical]
          background = "#1a1826"
          foreground = "#f5c2e7"
          timeout = 20
      '';

    };
    systemd.user.services.dunst = {
      enable = true;
      description = "dunst foo";
      wantedBy = [ "sway-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.dunst}/bin/dunst
        '';
        RestartSec = 5;
        Restart = "always";
      };
    };

    # systemd.user.services.mako = {
    #   enable = true;
    #   description = "Mako - Notificaitons for Wayland";
    #   documentation = [ "man:mako(5)" ];
    #   partOf = [ "sway-session.target" ];
    #   bindsTo = [ "sway-session.target" ];
    #   environment.PATH = lib.mkForce null;
    #   serviceConfig = {
    #     ExecStart = "${pkgs.mako}/bin/mako";
    #     Restart = "on-failure";
    #     RestartSec = 1;
    #     TimeoutStopSec = 10;
    #     Type = "simple";
    #   };
    # };
  };
}
