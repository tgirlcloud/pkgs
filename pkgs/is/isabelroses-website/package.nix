{
  lib,
  pnpm,
  just,
  nodejs-slim,
  stdenvNoCC,
  fetchPnpmDeps,
  pnpmConfigHook,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "isabelroses-website";
  version = "0-unstable-2026-03-16";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "website";
    rev = "a291abd71cf915f8aaeeca1ec06f0f0cc00a030c";
    hash = "sha256-4xiBIMslKM2MdBsgz33vdxrCKZdpjhvULw9FOUz/VOI=";
  };

  nativeBuildInputs = [
    just
    pnpm
    nodejs-slim
    pnpmConfigHook
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-QQvvBmPaj3WfzRrAvjjFswSaJj3QVf6rCTm/TeZ7FwM=";
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
