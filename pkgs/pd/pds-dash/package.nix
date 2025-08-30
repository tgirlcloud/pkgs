{
  lib,
  pnpm,
  stdenvNoCC,
  nodejs-slim,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pds-dash";
  version = "0-unstable-2025-08-30";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "pds-dash";
    rev = "e1a221aa08c533faf30d2a595ec2f68a0cdee4d1";
    hash = "sha256-iGOfjN4hWVTZcPNZ5Gw+2r2XXFssthvqqNS8f5bHpu8=";
  };

  nativeBuildInputs = [
    pnpm.configHook
    nodejs-slim
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-pKIwSI/iBL8MV4OWFHsPySdSlJb2JqnAl5re1KI9wlo=";
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
    description = "pds dashboard";
    homepage = "https://github.com/tgirlcloud/pds-dash";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "pds-dash";
    platforms = lib.platforms.all;
  };
})
