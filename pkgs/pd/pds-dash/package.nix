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
  version = "0-unstable-2025-10-05";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "pds-dash";
    rev = "6c2580efd445223e933ce5376161d21504970321";
    hash = "sha256-jZhYo1P9jmsKqIKpKIojVJIMO6GT6xsYSvbGebe+K4Y=";
  };

  nativeBuildInputs = [
    pnpm.configHook
    makeWrapper
    nodejs-slim
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-fahMn3hTTZwa75PuUP0D1vhR38rovvTHRrixwKM2+ng=";
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
