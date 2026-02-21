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
  version = "0-unstable-2026-02-20";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "website";
    rev = "ea103d4574b68fc72c564c635350b5ae2b26a572";
    hash = "sha256-KNkQIffSMaZjnyZyLqxIge8TNAnp0lBH+bXNOxwm668=";
  };

  nativeBuildInputs = [
    just
    pnpm
    nodejs_22
    pnpmConfigHook
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-YGUNsCRMxYmcmfrp2SIDByrvG8KkRh9VVlC7+RDtHqY=";
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
