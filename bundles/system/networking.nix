{
  nixos = {
    networking.networkmanager.enable = true;

    users.users.jamie.extraGroups = [ "networkmanager" ];
  };
}
