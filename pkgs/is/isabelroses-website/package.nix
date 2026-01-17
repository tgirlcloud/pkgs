{
  lib,
  pnpm,
  just,
  nodejs_22,
  stdenvNoCC,
  fetchPnpmDeps,
  pnpmConfigHook,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "isabelroses-website";
  version = "0-unstable-2026-01-16";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "website";
    rev = "4882bb83f11d5b19c05039aa0977e3f10eb260cf";
    hash = "sha256-u2Xed5iUaPU3jTbajjhRptNbuhVj/gOhxmRYasB0K5M=";
  };

  nativeBuildInputs = [
    just
    pnpm
    nodejs_22
    pnpmConfigHook
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-sM3rdJr5jdIm/IuIx7N9Vdszya8n9g9swm/Yfb4z4as=";
    fetcherVersion = 3;
  };

  dontUseJustInstall = true;
  dontUseJustCheck = true;

  env.ASTRO_TELEMETRY_DISABLED = 1;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -r dist/* "$out"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "isabelroses.com";
    homepage = "https://isabelroses.com/";
    license = with lib.licenses; [
      mit
      cc-by-nc-sa-40
    ];
    mainProgram = "isabelroses-website";
    maintainers = with lib.maintainers; [ isabelroses ];
  };
})
