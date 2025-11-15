{
  # config,
  pkgs,
  lib,
  isDesktop,
  ...
}:
let
  # isDesktop = abort specialArgs;
in
{
  imports = [
    ./i3blocks
  ];
  catppuccin = {
    sway.enable = isDesktop;
    mako.enable = isDesktop;
    bottom.enable = isDesktop;
  };

  wayland.windowManager.sway = with pkgs; {
    enable = isDesktop;
    systemd.enable = true;
    wrapperFeatures = {
      gtk = true;
    };
    config =
      let
      in
      {
        # modifier = "Alt_L";
        assigns = {
          "8" = [ { class = "vesktop"; } ];
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

        keybindings =
          let
            # modifier = config.wayland.windowManager.sway.config.modifier;
          in
          lib.mkOptionDefault {
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

              ${swaylock}/bin/swaylock -i /home/aubrey/Pictures/yuri/wintersunrise.png -c 000000
              pkill -n swayidle

              # safety call in case resume didn't finish executing
              swaymsg "output * power on"
            ''}";
            Print = "exec ${writeNushellScript "flameshot-screenie" ''
              let success = (${flameshot}/bin/flameshot gui -p ~/Pictures/Screenshots/ | complete | get exit_code) == 0;

              if $success {
                ls ~/Pictures/Screenshots/ | sort-by modified | last | get name | open | ${wl-clipboard}/bin/wl-copy
              }
            ''}";
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
              "timeout 300 'swaylock -i /home/aubrey/Pictures/yuri/wintersunrise.png -f -c 000000; '"
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
