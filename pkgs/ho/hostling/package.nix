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
  version = "0.3.1-unstable-2026-03-13";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "a74c81cb3f8ac69cdf454fea51dfe8e23b14e9e1";
    hash = "sha256-KohacXRQDXxebWERz7y3umIjy4mMtllIcmzjfmgUe5U=";
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
      hash = "sha256-vkAR33eOtdceYCr6Amc5ZspscQW65XkJp+o+Jhl4YYw=";
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

  vendorHash = "sha256-AEqtKBnmwnbbGcYPvlv/5noQgJaZJad8rR3gWXFFEQY=";

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
