{
  config,
  pkgs,
  lib,
  isDesktop,
  ...
}:
{
  imports = [
    ./i3blocks
  ];

  home.packages = with pkgs; [
    grim
    slurp
    xorg.setxkbmap
  ];

  wayland.windowManager.sway = with pkgs; {
    enable = isDesktop;
    systemd.enable = true;
    wrapperFeatures = {
      gtk = true;
    };
    config = {
      modifier = "Super";
      assigns = {
        "8" = [ { app_id = "vesktop"; } ];
        "1" = [ { class = "VSCodium"; } ];
        "2" = [ { app_id = "zen"; } ];
        "3" = [ { app_id = "org.wezfurlong.wezterm"; } ];
        "9" = [ { class = "1Password"; } ];
      };

      input = {
        "type:touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "enabled";
          middle_emulation = "enabled";
        };
      };

      left = "j";
      down = "k";
      up = "i";
      right = "l";

      keybindings =
        let
          cfg = config.wayland.windowManager.sway.config;
        in
        lib.mkForce {
          "${cfg.modifier}+Shift+q" = "kill";
          "${cfg.modifier}+d" = "exec ${cfg.menu}";

          # "${cfg.modifier}+${cfg.left}" = "focus left";
          # "${cfg.modifier}+${cfg.down}" = "focus down";
          # "${cfg.modifier}+${cfg.up}" = "focus up";
          # "${cfg.modifier}+${cfg.right}" = "focus right";

          "${cfg.modifier}+Left" = "focus left";
          "${cfg.modifier}+Down" = "focus down";
          "${cfg.modifier}+Up" = "focus up";
          "${cfg.modifier}+Right" = "focus right";

          # "${cfg.modifier}+Shift+${cfg.left}" = "move left";
          # "${cfg.modifier}+Shift+${cfg.down}" = "move down";
          # "${cfg.modifier}+Shift+${cfg.up}" = "move up";
          # "${cfg.modifier}+Shift+${cfg.right}" = "move right";

          "${cfg.modifier}+Shift+Left" = "move left";
          "${cfg.modifier}+Shift+Down" = "move down";
          "${cfg.modifier}+Shift+Up" = "move up";
          "${cfg.modifier}+Shift+Right" = "move right";

          "${cfg.modifier}+b" = "splith";
          "${cfg.modifier}+v" = "splitv";
          "${cfg.modifier}+f" = "fullscreen toggle";
          "${cfg.modifier}+a" = "focus parent";

          "${cfg.modifier}+s" = "layout stacking";
          "${cfg.modifier}+w" = "layout tabbed";
          "${cfg.modifier}+e" = "layout toggle split";

          "${cfg.modifier}+Shift+space" = "floating toggle";
          "${cfg.modifier}+space" = "focus mode_toggle";

          "${cfg.modifier}+1" = "workspace number 1";
          "${cfg.modifier}+2" = "workspace number 2";
          "${cfg.modifier}+3" = "workspace number 3";
          "${cfg.modifier}+4" = "workspace number 4";
          "${cfg.modifier}+5" = "workspace number 5";
          "${cfg.modifier}+6" = "workspace number 6";
          "${cfg.modifier}+7" = "workspace number 7";
          "${cfg.modifier}+8" = "workspace number 8";
          "${cfg.modifier}+9" = "workspace number 9";
          "${cfg.modifier}+0" = "workspace number 10";

          "${cfg.modifier}+Shift+1" = "move container to workspace number 1";
          "${cfg.modifier}+Shift+2" = "move container to workspace number 2";
          "${cfg.modifier}+Shift+3" = "move container to workspace number 3";
          "${cfg.modifier}+Shift+4" = "move container to workspace number 4";
          "${cfg.modifier}+Shift+5" = "move container to workspace number 5";
          "${cfg.modifier}+Shift+6" = "move container to workspace number 6";
          "${cfg.modifier}+Shift+7" = "move container to workspace number 7";
          "${cfg.modifier}+Shift+8" = "move container to workspace number 8";
          "${cfg.modifier}+Shift+9" = "move container to workspace number 9";
          "${cfg.modifier}+Shift+0" = "move container to workspace number 10";

          "${cfg.modifier}+Shift+minus" = "move scratchpad";
          "${cfg.modifier}+minus" = "scratchpad show";

          "${cfg.modifier}+Shift+c" = "reload";
          "${cfg.modifier}+Shift+e" =
            "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

          "${cfg.modifier}+r" = "mode resize";
          "--locked XF86AudioMute" = "exec ${wireplumber}/bin/wpctl set-mute @DEFAULT_SINK@ toggle";
          "--locked XF86AudioLowerVolume" = "exec ${wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 5%-";
          "--locked XF86AudioRaiseVolume" = "exec ${wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 5%+";
          "--locked XF86AudioPrev" = "exec ${playerctl}/bin/playerctl previous";
          "--locked XF86AudioPlay" = "exec ${playerctl}/bin/playerctl play-pause";
          "--locked XF86AudioNext" = "exec ${playerctl}/bin/playerctl next";
          "--locked XF86MonBrightnessDown" = "exec ${brightnessctl}/bin/brightnessctl set 5%-";
          "--locked XF86MonBrightnessUp" = "exec ${brightnessctl}/bin/brightnessctl set 5%+";

          "Mod4+L" = "exec ${writeNushellScript "sleep" ''
            swaymsg "exec ${swayidle}/bin/swayidle timeout 2 'swaymsg \"output * power off\"' resume 'swaymsg \"output * power on\"'"

            ${swaylock}/bin/swaylock -i ${./lock.png} -c 000000
            pkill -n swayidle

            # safety call in case resume didn't finish executing
            swaymsg "output * power on"
          ''}";
          Print = "exec ${writeNushellScript "grim-screenie" ''
            let path = $"/home/aubrey/Pictures/Screenshots/(date now | format date "%F_%H-%M-%S.png")";
            ${grim}/bin/grim -g (${slurp}/bin/slurp) $path
            open $path | wl-copy
          ''}";

          "--locked ${cfg.modifier}+Tab" = "exec fcitx5-remote -s tetra";
          "${cfg.modifier}+i" = "exec fcitx5-remote -s ipa-x-sampa";
          "${cfg.modifier}+j" = "exec fcitx5-remote -s mozc";
          "${cfg.modifier}+p" = "exec fcitx5-remote -s passthrough";
        };

      input = {
        "type:keyboard" = {
          xkb_layout = "tetra-us,sitelen-pona";
          xkb_options = "lv3:ralt_switch";
        };
      };

      output = {
        eDP-1 = {
          pos = "0 0";
          res = "2560x1600";
        };
        DP-2 = {
          pos = "2560 260";
          res = "1920x1080";
        };
        DP-4 = {
          pos = "4480 260";
          res = "1920x1080";
        };
      };

      startup = [
        # todo: something like this? maybe a whole ass nushell script that does this
        # exec --no-startup-id i3-msg 'workspace 3; exec iceweasel; workspace 1'
        { command = "${zen-browser}/bin/zen"; }
        { command = "${wezterm}/bin/wezterm"; }
        { command = "${_1password-gui}/bin/1password"; }
        { command = "${vscodium}/bin/zeditor"; }
        { command = "${vesktop}/bin/vesktop"; }
        {
          command = lib.concatStringsSep " " [
            "swayidle -w"
            "timeout 300 'swaylock -i ${./lock.png} -f -c 000000; '"
            "timeout 315 'swaymsg \"output * power off\"'"
            "resume 'swaymsg \"output * power on\"'"
            "before-sleep 'swaylock -f -c 000000'"
          ];
        }
      ];

      terminal = "${wezterm}/bin/wezterm start --always-new-process";

      window.commands = [
        {
          command = "border pixel 0, floating enable, fullscreen disable, move absolute position 0 0";
          criteria = {
            title = "flameshot";
          };
        }
        {
          command = "floating enable";
          criteria = {
            title = ".*(?!Godot Engine)";
            instance = "Godot_Engine";
          };
        }
      ];

      workspaceAutoBackAndForth = true;
      workspaceLayout = "tabbed";
      workspaceOutputAssign = [
        {
          output = "eDP-1";
          workspace = "8";
        }
        {
          output = "DP-2";
          workspace = "2";
        }
        {
          output = "DP-2";
          workspace = "3";
        }
        {
          output = "DP-2";
          workspace = "1";
        }
        {
          output = "DP-4";
          workspace = "9";
        }
      ];
    };
  };

  programs = {
    wofi = {
      enable = isDesktop;
      settings = {
        allow_markup = true;
        width = 250;
      };
    };

    swaylock = {
      enable = isDesktop;
    };
  };
}
