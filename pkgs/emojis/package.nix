{
  lib,
  unzip,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "emojis";
  version = "0.1.4";

  src = lib.filterSource (path: _: lib.baseNameOf path != ".zip") ./.;

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    unzip $src/emojis.zip
    cp * $out
    runHook postInstall
  '';

  meta = {
    description = "emojis repacked as APNG";
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
