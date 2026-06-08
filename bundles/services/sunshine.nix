{ bundleLib, ... }:
bundleLib.mkEnableModule [ "gaia" "services" "sunshine" ] {

  nixos =
    { pkgs, ... }:
    {
      services.sunshine = {
        enable = true;
        autoStart = true;
        capSysAdmin = true; # Wayland
        openFirewall = true;
        settings = {
          output_name = 1;
          min_log_level = "info";
        };
        applications = {
          env = {
            PATH = "$(PATH):/run/current-system/sw/bin:/etc/profiles/per-user/jamie/bin:$(HOME)/.local/bin";
          };
          apps =
            let
              notif = msg: ''hyprctl notify 1 2500 "rgb(000000)" "${msg}"'';

              onConnect = pkgs.writeShellScript "onConnect" ''
                ${notif "Creating virtual monitor 'Virtual'..."}
                hyprctl output create headless Virtual
                sleep 0.2

                ${notif "Configuring 'Virtual' resolution..."}
                hyprctl keyword monitor Virtual,"$SUNSHINE_CLIENT_WIDTH"x"$SUNSHINE_CLIENT_HEIGHT"@"$SUNSHINE_CLIENT_FPS",auto,1
                sleep 0.2

                hyprctl dispatch workspace 'sunshine'
                sleep 0.6

                if pgrep -x steam &>/dev/null; then
                    ${notif "Steam already runninng. Killing instance..."}
                    steam -shutdown
                    while pgrep -x steam &>/dev/null; do
                        sleep 1
                    done
                    ${notif "Killed!"}
                fi

                ${notif "Starting Steam in Gamescope..."}
                gamemoderun gamescope -f -e --adaptive-sync -- steam -bigpicture
              '';

              onDisconnect = pkgs.writeShellScript "onDisconnect" ''
                if pgrep -x steam &>/dev/null; then
                    ${notif "Killing Steam..."}
                    steam -shutdown
                    while pgrep -x steam &>/dev/null; do
                        sleep 1
                    done
                    ${notif "Killed!"}
                fi

                hyprctl output remove Virtual
                sleep 0.3

                # Reset config and monitors
                hyprctl reload
                sleep 0.3
              '';
            in
            [
              {
                name = "Desktop";
                auto-detach = "true";
                exclude-global-prep-cmd = "false";
              }
              {
                name = "Steam Big Picture";
                exclude-global-prep-cmd = "false";
                prep-cmd = [
                  {
                    do = "sudo -u jamie '${onConnect}'";
                    undo = "sudo -u jamie '${onDisconnect}'";
                  }
                ];
              }
            ];
        };
      };
    };

}
