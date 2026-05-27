{ self', ... }:
{
  nixos =
    { pkgs, ... }:
    let
      subdomain = "jellyfin";
      domain = "warm.vodka";
      port = 8096;
    in
    {
      services.jellyfin = {
        enable = true;
      };

      services.caddy.virtualHosts."${subdomain}.${domain}".extraConfig = ''
        reverse_proxy :${toString port}
      '';
    };
}

