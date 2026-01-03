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
  version = "0-unstable-2025-11-20";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "site";
    rev = "d6736ca72900e681b095ba805e6fabe688fd269a";
    hash = "sha256-N9zLHWGF03n4fQdmglr+yL3N0ntW6dpCmBRjRW/MGh8=";
  };

  nativeBuildInputs = [
    pnpm
    nodejs-slim
    pnpmConfigHook
  ];

  env.ASTRO_TELEMETRY_DISABLED = 1;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-PDAxD0T9SddXmkJPx5IsJIbCU/5pfWaHFZCJF8Eu3Bw=";
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
