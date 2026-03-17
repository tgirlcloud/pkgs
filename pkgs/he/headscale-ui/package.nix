{
  lib,
  stdenv,
  fetchzip,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "headscale-ui";
  version = "2026.03.17";

  src = fetchzip {
    url = "https://github.com/gurucomputing/headscale-ui/releases/download/${finalAttrs.version}/headscale-ui.zip";
    hash = "sha256-+PgogmoY/lEo4cHN3Taf69xAnz7v/E6hsvHsoq+kX4M=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/
    cp -r * $out/share/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Web frontend for the headscale Tailscale-compatible coordination server";
    homepage = "https://github.com/gurucomputing/headscale-ui";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
})
