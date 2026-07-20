let
  username = "jamie";
  sshKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINnFEMa0S9zuA5cVg+Ktazz9gEevkDCNYIDX0WAMxcAC eos"
  ];
in
{
  nixos = {
    users = {
      mutableUsers = false; # forces declaration of user and group adding and modification
      users.${username} = {
        isNormalUser = true;
        hashedPassword = "$y$j9T$hyPw7ecQ4UMGe5ArOW0bD/$3Oz3yxROROz1eU9u3DiGB5y8a7g4mD/E3AIOx2Pm8x0";
        extraGroups = [
          "users" # default user group for users
          "wheel" # sudo
        ];
        openssh.authorizedKeys.keys = sshKeys;
      };
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };

    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
  };

  home-manager =
    { config, ... }:
    {
      home = {
        inherit username;
        homeDirectory = "/home/${username}";
        preferXdgDirectories = true;
      };

      xresources.path = "${config.xdg.configHome}/.Xresources";

      xdg.portal.xdgOpenUsePortal = true;
    };

}
