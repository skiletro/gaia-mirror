{ bundleLib, ... }:
bundleLib.mkEnableModule [ "gaia" "services" "syncthing" ] {

  gaia.autoStart = [ "syncthingtray --wait" ];

  nixos =
    { pkgs, ... }:
    {
      services.syncthing = {
        enable = true;
        openDefaultPorts = true;
      };

      environment.systemPackages = [ pkgs.syncthingtray-minimal ];
    };

}
