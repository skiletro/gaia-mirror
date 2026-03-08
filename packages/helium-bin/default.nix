{
  stdenvNoCC,
  appimageTools,
  sources,
  lib,
  _7zz,
  ...
}:
let
  inherit (stdenvNoCC.hostPlatform) isDarwin;

  linuxDerivation = appimageTools.wrapType2 rec {
    pname = "helium";

    inherit (sources.helium-appimage) version src;

    extraInstallCommands =
      let
        contents = appimageTools.extract { inherit pname version src; };
      in
      ''
        install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace 'Exec=AppRun' 'Exec=${pname}'
        cp -r ${contents}/usr/share/icons $out/share
      '';
    meta.mainProgram = "helium";
  };

  darwinDerivation = stdenvNoCC.mkDerivation {
    inherit (sources.helium-dmg) pname version src;

    phases = [
      "unpackPhase"
      "installPhase"
    ];

    buildInputs = [ _7zz ];

    unpackPhase = ''
      7zz x -snld $src
    '';

    installPhase = ''
      mkdir -p $out/Applications
      mv Helium.app $out/Applications
    '';

  };
in
lib.mergeAttrs {
  meta = {
    description = "Chromium-based web browser";
  };
} (if isDarwin then darwinDerivation else linuxDerivation)
