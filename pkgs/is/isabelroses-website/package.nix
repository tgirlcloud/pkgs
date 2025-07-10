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
  version = "0-unstable-2025-07-09";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "website";
    rev = "0b892e20268697b0b5275ab152e987539f014543";
    hash = "sha256-YqbS4/MLWI7V/407yUZVB8/DTjWN/ge/zoY2DCkTU5g=";
  };

  nativeBuildInputs = [
    just
    dart-sass
    nodejs
    pnpm.configHook
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-VZ2isg5A9RT9Y4sHypgyZhLIWQGM+dXejgNOcUWfpsk=";
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
