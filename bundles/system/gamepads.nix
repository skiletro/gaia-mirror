{ bundleLib, ... }:
bundleLib.mkEnableModule [ "gaia" "system" "gamepads" ] {

  nixos = {
    hardware = {
      xone.enable = true;
      xpadneo.enable = true;
      xpad-noone.enable = true;
    };
  };

}
