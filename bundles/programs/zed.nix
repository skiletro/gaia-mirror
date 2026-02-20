{ bundleLib, ... }:
bundleLib.mkEnableModule [ "gaia" "programs" "zed" ] {

  home-manager =
    { pkgs, ... }:
    {
      programs.zed-editor = {
        enable = true;
        extensions = [
          "nix"
        ];
        userSettings = {
          # keep-sorted start block=yes
          auto_update = false;
          collaboration_panel.button = false;
          colorize_brackets = true;
          disable_ai = true;
          features.edit_prediction_provider = "none";
          helix_mode = true;
          load_direnv = "shell_hook";
          relative_line_numbers = true;
          restore_on_startup = "none";
          search.regex = false;
          tab_bar = {
            show = false;
            show_nav_history_buttons = false;
          };
          telemetry = {
            metrics = false;
            diagnostics = false;
          };
          title_bar.show_sign_in = false;
          # keep-sorted end
        };
        extraPackages = with pkgs; [
          nixd
          nil
        ];
      };
    };

}
