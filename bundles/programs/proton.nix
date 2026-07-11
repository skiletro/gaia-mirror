{ bundleLib, ... }:
bundleLib.mkEnableModule [ "gaia" "programs" "proton" ] {

  home-manager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        protonmail-desktop
        proton-pass
        proton-pass-cli
        protonvpn-gui
        proton-vpn-cli
      ];
    };

}
