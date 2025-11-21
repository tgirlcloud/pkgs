{
  lib,
  pnpm,
  nodejs,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "TidaLuna";
  version = "1.7.0-beta-unstable-2025-11-20";

  src = fetchFromGitHub {
    owner = "Inrixia";
    repo = "TidaLuna";
    rev = "aa0125d933537001a268d62d688d4bdae4f09963";
    hash = "sha256-9+9EjH6lNfxAVjS7+XO09MgAD+KYmVA3sXs5FlUsg/o=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname src version;
    fetcherVersion = 2;
    hash = "sha256-EvAmarFUKK1BH0VLISu56p/wgY3IuTYu4mj7qYoCQoU=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
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
