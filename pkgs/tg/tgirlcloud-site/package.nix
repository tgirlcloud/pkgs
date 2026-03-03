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
  version = "0-unstable-2026-03-02";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "site";
    rev = "d843694c6931c3289c8f3a71f1862aa1ab774dc3";
    hash = "sha256-mK69cpuuWKF7gNgc+yF06AHDW0jd8t05f980HrMdQM4=";
  };

  nativeBuildInputs = [
    pnpm
    nodejs-slim
    pnpmConfigHook
  ];

  env.ASTRO_TELEMETRY_DISABLED = 1;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-yMgJKZoLWtDczlxWBc9qOlompRU0F2d2HURFPptsmkg=";
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
