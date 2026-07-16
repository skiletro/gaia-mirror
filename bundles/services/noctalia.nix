{ bundleLib, inputs, ... }:
bundleLib.mkEnableModule [ "gaia" "services" "noctalia" ] {

  home-manager = {
    imports = [ inputs.noctalia.homeModules.default ];

    programs.noctalia = {
      enable = true;
      systemd.enable = true;
    };
  };

}
