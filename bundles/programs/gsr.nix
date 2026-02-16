{ bundleLib, ... }:
bundleLib.mkEnableModule [ "gaia" "programs" "gsr" ] {

  nixos.programs'.gpu-screen-recorder-ui.enable = true;

}
