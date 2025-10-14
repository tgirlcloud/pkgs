{
  lib,
  pnpm,
  stdenvNoCC,
  nodejs-slim,
  makeWrapper,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pds-dash";
  version = "0-unstable-2025-10-13";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "pds-dash";
    rev = "4871dbfa2ddb42ef82fee3bfff2f59e7ccd268f6";
    hash = "sha256-hGN4yQMr2NB1flSsT5COhbDZBh3kAV8Giq7/buyLTPs=";
  };

  nativeBuildInputs = [
    pnpm.configHook
    makeWrapper
    nodejs-slim
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-xdznrMW6C5FVd4qhNtRUA3uSIeAMbfX3092n1s2lT2A=";
    fetcherVersion = 2;
  };

  env.ASTRO_TELEMETRY_DISABLED = 1;

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    cp -r node_modules $out/node_modules
    cp -r dist/* $out

    makeWrapper ${nodejs-slim}/bin/node $out/bin/pds-dash \
      --add-flags "$out/server/entry.mjs"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "pds dashboard";
    homepage = "https://github.com/tgirlcloud/pds-dash";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "pds-dash";
    platforms = lib.platforms.all;
  };
})
