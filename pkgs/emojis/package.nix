{
  lib,
  unzip,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "emojis";
  version = "0.1.4";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = ./emojis.zip;
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    unzip $src/emojis.zip
    cp * $out
    rm -rf $out/emojis.zip
    runHook postInstall
  '';

  meta = {
    description = "emojis repacked as APNG";
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
