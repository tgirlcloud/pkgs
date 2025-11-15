{
  lib,
  pnpm,
  nodejs-slim,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tgirlcloud-site";
  version = "0-unstable-2025-11-14";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "site";
    rev = "7c5c2738c77b06268333263757b38d74810b69c5";
    hash = "sha256-Qckt3gFkeiiE6hTpn4qXplkd3X+EsgNPevDlG54kNmI=";
  };

  nativeBuildInputs = [
    pnpm.configHook
    nodejs-slim
  ];

  env.ASTRO_TELEMETRY_DISABLED = 1;

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-tRpsNdYVyNDPiMgn353fxnxLxktr3+FbnHYqkT7OJYE=";
    fetcherVersion = 2;
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
