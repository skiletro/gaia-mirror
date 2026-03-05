{ self, ... }:
let
  flakeConfig = (import "${self}/flake.nix").nixConfig;

  settings = pkgs: {
    nixpkgs = {
      overlays = [
        (_final: prev: {
          inherit (prev.lixPackageSets.stable)
            nixpkgs-review
            nix-eval-jobs
            nix-fast-build
            colmena
            ;
        })
      ];
      config = {
        allowUnfree = true;
      };
    };

    nix = {
      enable = true;
      package = pkgs.lixPackageSets.stable.lix;
      channel.enable = false;
      settings = {
        extra-substituters = flakeConfig.extra-trusted-substituters;
        inherit (flakeConfig) extra-trusted-substituters extra-trusted-public-keys;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = [
          "jamie"
          "root"
          "@wheel"
        ]; # Fixes some "cannot connect to socket" issues
        warn-dirty = false;
        http-connections = 50;
        log-lines = 50;
        builders-use-substitutes = true;
        accept-flake-config = true;
      };
    };
  };
in
{
  nixos =
    { pkgs, ... }:
    {
      inherit (settings pkgs) nix nixpkgs;
    };

  darwin =
    { pkgs, ... }:
    {
      inherit (settings pkgs) nix nixpkgs;
    };

  home-manager.nixpkgs.config.allowUnfree = true;
}
