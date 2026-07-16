{ bundleLib, inputs, ... }:
bundleLib.mkEnableModule [ "gaia" "system" "greeter" ] {

  nixos = {

    imports = [ inputs.noctalia-greeter.nixosModules.default ];

    programs.noctalia-greeter = {
      enable = true;
      settings.keyboard.layout = "gb";
    };

  };

}
