{
  lib,
  pnpm,
  stdenvNoCC,
  nodejs-slim,
  fetchPnpmDeps,
  pnpmConfigHook,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tgirlcloud-site";
  version = "0-unstable-2026-01-16";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "site";
    rev = "1a820dabf72d71f2b6cd7c5559a2e8792df6c72b";
    hash = "sha256-r/Jr7qGWE7b/NPfvS+q2foQSU80NR8guSAOvz/p1STQ=";
  };

  nativeBuildInputs = [
    pnpm
    nodejs-slim
    pnpmConfigHook
  ];

  env.ASTRO_TELEMETRY_DISABLED = 1;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-XVgm3StLGN8rGqhm3FgE4Z0DFjofxQzOIgtC9LxQC1c=";
    fetcherVersion = 3;
  };

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r dist/* $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "The source code tgirl.cloud site";
    homepage = "https://github.com/tgirlcloud/site";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
})
