{
  lib,
  unzip,
  stdenv,
  fetchurl,
  nix-update-script,
}:
let
  pname = "headscale-ui";
  version = "2025.03.21";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/gurucomputing/${pname}/releases/download/${version}/headscale-ui.zip";
    sha256 = "sha256-Rk/nY9G0uZZjsLFkrwwwLXVS4vBQQ7YEfhYCg9NM6cU=";
  };

  buildInputs = [ unzip ];

  dontStrip = true;

  unpackPhase = ''
    runHook preUnpack
    unzip $src
    runHook postUnpack
  '';

  installPhase = ''
    mkdir -p $out/share/
    cp -r web/ $out/share/
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A web frontend for the headscale Tailscale-compatible coordination server";
    homepage = "https://github.com/gurucomputing/headscale-ui";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
