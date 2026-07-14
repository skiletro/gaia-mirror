{ bundleLib, lib, ... }:
bundleLib.mkEnableModule [ "gaia" "system" "greeter" ] {

  nixos =
    { config, ... }:
    {

    };
}
