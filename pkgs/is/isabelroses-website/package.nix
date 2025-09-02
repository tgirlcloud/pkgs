{
  lib,
  just,
  dart-sass,
  stdenvNoCC,
  nodejs_22,
  pnpm_10,
  fetchFromGitHub,
  nix-update-script,
}:
let
  nodejs = nodejs_22;
  pnpm = pnpm_10.override { inherit nodejs; };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "isabelroses-website";
  version = "0-unstable-2025-09-01";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "website";
    rev = "5f38306ee66b4c954cb385eb73ef1ac75ef88ad1";
    hash = "sha256-ZXNZQUpq/sv86iL9y5Y2Khq0AdwDD0w2acN6XAfvOpg=";
  };

  nativeBuildInputs = [
    just
    dart-sass
    nodejs
    pnpm.configHook
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-/7uhKfbzErQSt6D4aGRKpqK0hnVMcYTfhKd7gJ7pfUU=";
    fetcherVersion = 2;
  };

  dontUseJustInstall = true;
  dontUseJustCheck = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -r dist/* "$out"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "isabelroses.com";
    homepage = "https://isabelroses.com/";
    license = with lib.licenses; [
      mit
      cc-by-nc-sa-40
    ];
    mainProgram = "isabelroses-website";
    maintainers = with lib.maintainers; [ isabelroses ];
  };
})
