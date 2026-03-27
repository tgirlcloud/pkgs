{
  lib,
  nodejs,
  stdenv,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  fetchFromGitHub,
  nix-update-script,
}:
let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hostling-frontend";
  version = "0.3.1-unstable-2026-03-26";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "4334664a81d9ce641d2442c2a644cedcaa87952a";
    hash = "sha256-J+c1XMIIgsCWZPTrT3VcFqQSEwpM3bzCDlGXFId5M8Y=";
  };

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
    hash = "sha256-MxnhpZ39X8SE/dLEUTqSdbdwjJ323J+D1cjvrHuR7RE=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm run build --outDir=$out

    runHook postBuild
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Simple file hosting service";
    homepage = "https://github.com/BatteredBunny/hostling";
    license = lib.licenses.mit;
    mainProgram = "hostling";
    maintainers = with lib.maintainers; [ isabelroses ];
  };
})
