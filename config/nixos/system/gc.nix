{ config, lib, ... }:
{
  config = lib.mkIf config.nix.enable {
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
