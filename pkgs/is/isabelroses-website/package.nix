{
  lib,
  just,
  stdenvNoCC,
  nodejs_22,
  pnpm_10,
  fetchFromGitHub,
  nix-update-script,
}:
let
  nodejs = nodejs_22;
  pnpm = pnpm_10.override { inherit nodejs; };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "isabelroses-website";
  version = "0-unstable-2025-10-19";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "website";
    rev = "e1fa3f23b68c39f2d895f17dd172fd01799f34b6";
    hash = "sha256-sQczoF7MYu8a1zDus0Aq8SjobaDkVuHyTa82VjLIbq8=";
  };

  nativeBuildInputs = [
    just
    nodejs
    pnpm.configHook
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-JN9/SjdTLFh3hDo6OTaYyJWFlYiH7roHfUlX55/Gc38=";
    fetcherVersion = 2;
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
