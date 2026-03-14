{ bundleLib, self', ... }:
bundleLib.mkEnableModule [ "gaia" "system" "fonts" ] {

  nixos = {
    fonts.fontDir.enable = true;

    environment.sessionVariables.FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
  };

  home-manager =
    { pkgs, ... }:
    {
      fonts.fontconfig = {
        enable = true;
        antialiasing = true;
        hinting = "full";
      };

      home.packages = with pkgs; [
        corefonts # Microsoft Fonts
        vista-fonts # More Microsoft Fonts
        noto-fonts
        noto-fonts-cjk-sans # Japanese, Korean, Chinese, etc
        noto-fonts-color-emoji
        self'.packages.pragmata-pro
        self'.packages.pragmata-pro-nf
      ];
    };

}
