{
  lib,
  pnpm,
  nodejs,
  stdenvNoCC,
  fetchPnpmDeps,
  pnpmConfigHook,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "TidaLuna";
  version = "1.9.9-beta-unstable-2026-01-23";

  src = fetchFromGitHub {
    owner = "Inrixia";
    repo = "TidaLuna";
    rev = "68d4609af63e8a548e68f2ab64c2b7b9d4090b15";
    hash = "sha256-+cQwI79/8hOd5ywnnISXrQvLeweGZsuo6QZMnn1j8gI=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname src version;
    fetcherVersion = 3;
    hash = "sha256-lViiHCJhRpKTKVH2ALf82JUBU03gmFMWHTgV2RFaBnw=";
  };

  nativeBuildInputs = [
    pnpm
    nodejs
    pnpmConfigHook
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -R "dist" "$out"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Client mod for the Tidal music client & successor to Neptune";
    homepage = "https://github.com/Inrixia/TidaLuna";
    license = lib.licenses.mspl;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
})
