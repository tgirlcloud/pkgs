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
  version = "0-unstable-2026-01-16";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "pds-dash";
    rev = "1170cac2f11be12686b6c1ab30c3ff46206b3461";
    hash = "sha256-QYbLVnI3ctcI3EfkUwY7v5emxKzRhrC7cex+JCRF7ys=";
  };

  nativeBuildInputs = [
    pnpm
    nodejs-slim
    makeWrapper
    pnpmConfigHook
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-FkqNCT5KvCAphwFiWrzs8QOQSryfHBFTq9T6qeNRlNs=";
    fetcherVersion = 3;
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
