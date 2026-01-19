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
  version = "1.8.2-beta-unstable-2026-01-18";

  src = fetchFromGitHub {
    owner = "Inrixia";
    repo = "TidaLuna";
    rev = "a012a2271d2ab7fdb80b0c7e2c261236f8fce6da";
    hash = "sha256-muH7S7JwINfy4LTAqtCjPAWRz02LjZNmFpZsv2/K2x4=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname src version;
    fetcherVersion = 3;
    hash = "sha256-ifJfJX1snSiRqokjP7JhIauLZAfX8B1GbLJ3ooFCwZE=";
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
