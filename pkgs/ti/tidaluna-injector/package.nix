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
  version = "1.6.15-beta-unstable-2025-11-08";

  src = fetchFromGitHub {
    owner = "Inrixia";
    repo = "TidaLuna";
    rev = "c996cd055a647d711badaebc7db9e5a377c6b9ce";
    hash = "sha256-sL3j250M3Xbpqy0yygdFbrl4s94jqzW2U0te2vVgIL0=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname src version;
    fetcherVersion = 2;
    hash = "sha256-ZuwEiqhIzZ+4v93T/gMGj2ngl4Jpjk0PG70z+x4RLew=";
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
