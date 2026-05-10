{
  inputs,
  inputs',
  self',
  lib,
  ...
}:
let
  # https://tinted-theming.github.io/tinted-gallery/#base16-evenok-dark
  sharedStylixConfig = config: pkgs: {
    base16Scheme = "${self'.packages.base16-schemes}/share/themes/evenok-dark.yaml";
    override = {
      scheme = "Evenok OLED";
      base00 = "000000";
      base01 = "080808";
      base0D = "9095ff";
      base0E = "00aff2";
    };
    polarity = "dark";
    fonts = {
      sansSerif = {
        package = self'.packages.space-grotesk;
        name = "Space Grotesk";
      };
      serif = config.stylix.fonts.sansSerif; # Set serif font to the same as the sans-serif
      monospace = {
        package = self'.packages.pragmata-pro;
        name = "PragmataPro Mono Liga";
      };
      emoji = {
        package = self'.packages.apple-emoji;
        name = "Apple Color Emoji";
      };

      sizes = {
        applications = 10;
        desktop = 10;
        popups = 10;
        terminal = 14;
      };
    };
    image =
      let
        wallpaper = pkgs.fetchurl {
          url = "https://w.wallhaven.cc/full/3k/wallhaven-3k5zgy.jpg";
          sha256 = "0g995gd4zpyhz5fxlh6grid4r02yaz46s1cnn21frzs2pc3pr9mp";
        };
      in
      pkgs.runCommand "output.png" { }
        "${lib.getExe pkgs.lutgen} apply ${wallpaper} -o $out -- ${builtins.concatStringsSep " " config.lib.stylix.colors.toList}";
  };
in
{
  nixos =
    { config, pkgs, ... }:
    {
      imports = [ inputs.stylix.nixosModules.stylix ];

      stylix = {
        enable = true;
        cursor = {
          package =
            with config.lib.stylix.colors.withHashtag;
            inputs'.cursors.packages.apple-cursor.override {
              background_color = base00;
              outline_color = base06;
              accent_color = base00;
            };
          name = "Apple-Custom";
          size = 24;
        };

        opacity = {
          applications = 0.85;
          popups = 0.85;
          terminal = 0.85;
        };
      }
      // (sharedStylixConfig config pkgs);
    };

  home-manager =
    { pkgs, config, ... }:
    {
      stylix.icons = {
        enable = lib.mkIf pkgs.stdenvNoCC.hostPlatform.isLinux true;
        package = pkgs.morewaita-icon-theme;
        dark = "MoreWaita";
        light = "MoreWaita";
      };

      stylix.fonts.sizes.terminal = lib.mkIf pkgs.stdenvNoCC.isDarwin (lib.mkForce 16); # macos scaling is weird.

      gtk.gtk4.theme = config.gtk.theme;
    };

  darwin =
    { pkgs, config, ... }:
    {
      imports = [ inputs.stylix.darwinModules.stylix ];

      stylix = {
        enable = true;
      }
      // (sharedStylixConfig config pkgs);

      system = {
        activationScripts.postActivation.text =
          # bash
          ''
            printf >&2 '%b' 'Setting \033[0;35mStylix\e[0m wallpaper...\n'
            osascript -e 'tell application "System Events" to tell every desktop to set picture to "${config.stylix.image}" as POSIX file'
          '';

        defaults = {
          NSGlobalDomain = {
            AppleInterfaceStyle = "Dark";
            AppleInterfaceStyleSwitchesAutomatically = false;
            NSStatusItemSpacing = 8; # default=12
            NSStatusItemSelectionPadding = 6; # default=6
            _HIHideMenuBar = false;
            NSAutomaticWindowAnimationsEnabled = false;
          };
          spaces.spans-displays = true;
          dock.expose-group-apps = true;
        };
      };
    };
}
