{
  lib,
  nodejs,
  stdenv,
  pnpm_10,
  fetchPnpmDeps,
  buildGoModule,
  pnpmConfigHook,
  fetchFromGitHub,
  nix-update-script,
}:
let
  pnpm = pnpm_10;
  version = "0.3.1-unstable-2026-03-03";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "6f2e4fcb4b95d067b54e80cca65d65b205fd3ce8";
    hash = "sha256-xXbFG1oChAwTYofq8CP5SfRx2qWcHyawatN5x19S8Yk=";
  };

  meta = {
    description = "Simple file hosting service";
    homepage = "https://github.com/BatteredBunny/hostling";
    license = lib.licenses.mit;
    mainProgram = "hostling";
    maintainers = with lib.maintainers; [ isabelroses ];
  };

  frontend = stdenv.mkDerivation (finalAttrs: {
    pname = "hostling-frontend";
    inherit version src meta;

    sourceRoot = "${finalAttrs.src.name}/frontend";

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm
    ];

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs)
        pname
        version
        src
        sourceRoot
        ;
      inherit pnpm;
      fetcherVersion = 3;
      hash = "sha256-EPPGd8MVsALw5SOCgem8AXPo4ZeFcCF8eiQ/Uq7ega8=";
    };

    buildPhase = ''
      runHook preBuild

      pnpm run build --outDir=$out

      runHook postBuild
    '';
  });
in
buildGoModule {
  pname = "hostling";
  inherit version src meta;

  vendorHash = "sha256-S1RH5he1GBdJhnpG5gOmhcL8Z2KqZyE7db5hecenzYs=";

  prePatch = ''
    cp -r ${frontend} ./public/dist
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version"
        "branch=HEAD"
      ];
    };

    inherit frontend;
  };
}
