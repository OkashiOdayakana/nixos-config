{ rootPath, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      ${builtins.readFile ./mocha.css}
      * {
        min-height: 0;
        font-size: 1.2rem;
      }

      #workspaces {
          margin-left: 6px;
      }
      #workspaces button {
          color: @text;
      }
      #waybar {
          background: transparent;
          color: @text;
          margin: 5px 5px;
      }
      window#waybar {
        /* you can also GTK3 CSS functions! */
        color: @text;
        background-color: shade(@base, 0.9);
        border: 2px solid alpha(@crust, 0.3);
      }
      #network,
      #tray,
      #backlight,
      #clock,
      #battery,
      #wireplumber,
      #custom-lock,
      #custom-power {
        background-color: @surface0;
        padding: 0.5rem 1rem;
        margin: 5px 0;
      }
      #clock {
        color: @blue;
        border-radius: 0px 1rem 1rem 0px;
        margin-right: 1rem;
      }
      #battery {
        color: @green;
      }
      #battery.charging {
        color: @green;
      }

      #battery.warning:not(.charging) {
        color: @red;
      }

      #backlight {
        color: @yellow;
      }

      #backlight, #battery {
        border-radius: 0;
      }

      #wireplumber {
        color: @maroon;
        border-radius: 1rem 0px 0px 1rem;
        margin-left: 1rem;
      }
    '';
    settings = [
      {
        height = 30;
        layer = "top";
        position = "top";
        tray = {
          spacing = 10;
        };
        modules-left = [ "niri/workspaces" ];
        modules-center = [ "niri/window" ];
        modules-right = [
          "wireplumber"
          "network"
          "backlight"
          "battery"
          "clock"
          "tray"
        ];
        wireplumber = {
          max-volume = 100;
        };
        battery = {
          format = "{capacity}% {icon}";
          format-alt = "{time} {icon}";
          format-charging = "{capacity}% ";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          format-plugged = "{capacity}% ";
          states = {
            critical = 15;
            warning = 30;
          };
        };
        clock = {
          format = "{:%I:%M}";
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "{:%Y-%m-%d | %I:%M}";
        };
        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        memory = {
          format = "{}% ";
        };
        network = {
          interval = 1;
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          format-disconnected = "Disconnected ⚠";
          format-ethernet = "{ifname}: {ipaddr}/{cidr}   up: {bandwidthUpBits} down: {bandwidthDownBits}";
          format-linked = "{ifname} (No IP) ";
          format-wifi = "{essid} ";
        };
      }
    ];
  };
}
