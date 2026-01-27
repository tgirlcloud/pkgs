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
  version = "1.9.14-beta-unstable-2026-01-27";

  src = fetchFromGitHub {
    owner = "Inrixia";
    repo = "TidaLuna";
    rev = "291ece0d97feb4a6e91d72a85793009f68fe323a";
    hash = "sha256-6UfGHrCQOtK+ts2FdJ3l74SiALgf5JJL3N7+jgspqFU=";
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
