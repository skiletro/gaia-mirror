let
  nixpkgs.config = {
    allowUnfree = true;
  };
in
{
  nixos = { inherit nixpkgs; };

  darwin = { inherit nixpkgs; };
}
