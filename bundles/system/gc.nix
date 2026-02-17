{
  nixos = {
    programs.nh = {
      enable = true;
      flake = "/home/jamie/Projects/gaia";
      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 3";
      };
    };
  };
}
