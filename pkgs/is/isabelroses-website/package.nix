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
  version = "0-unstable-2026-01-29";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "website";
    rev = "3f58cbe27f943c23903d7374a3e66dec2b65677a";
    hash = "sha256-QlpEtSZnzvK6WtOPe3G1AIPRBT9AMT1yGxmd8j7QP/8=";
  };

  nativeBuildInputs = [
    just
    pnpm
    nodejs_22
    pnpmConfigHook
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-gaC4FUdwbixfCDpqu/tm0lGz322NVO90qviaWjGvnVg=";
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
