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
  version = "0-unstable-2026-03-05";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "site";
    rev = "912b5a6a232e77a7358f754dd0d619fe648ed906";
    hash = "sha256-fpq67teArRIhZL/SbOgnANE3Hk9K3GFEMmkUFmiNveY=";
  };

  nativeBuildInputs = [
    pnpm
    nodejs-slim
    pnpmConfigHook
  ];

  env.ASTRO_TELEMETRY_DISABLED = 1;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-y2ufu2WJMTFQ9EP8up4kXro/Ckim3UnPHzfmOA4Kf+A=";
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
