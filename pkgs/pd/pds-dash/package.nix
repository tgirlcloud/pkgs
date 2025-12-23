{
  lib,
  pnpm,
  stdenvNoCC,
  makeWrapper,
  nodejs-slim,
  fetchPnpmDeps,
  pnpmConfigHook,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pds-dash";
  version = "0-unstable-2025-11-20";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "pds-dash";
    rev = "50abff179da3d573da30caa9d177972c22f5fe5e";
    hash = "sha256-Ct3hmD6DoNeWovqt8JnKwcIUJSr2OB8WzMf71Oo/lSY=";
  };

  nativeBuildInputs = [
    pnpm
    nodejs-slim
    makeWrapper
    pnpmConfigHook
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-+yX0Bfw5HC74IMCO+zr6ZFqr8c6NOFa7gD15PmU0nYI=";
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
