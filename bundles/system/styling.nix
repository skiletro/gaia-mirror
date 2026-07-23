{
  inputs,
  inputs',
  self',
  lib,
  ...
}:
let
  sharedStylixConfig = config: pkgs: {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/chalk.yaml";
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
    { pkgs, ... }:
    {
      stylix.icons = {
        enable = true;
        package = pkgs.morewaita-icon-theme;
        dark = "MoreWaita";
        light = "MoreWaita";
      };

      home.pointerCursor.enable = true;
    };
}
