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
  version = "0-unstable-2025-04-23";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "website";
    rev = "2beec34b2a9cd6bff932c045e37300c4aca14ec6";
    hash = "sha256-1VRCPd/atEvSARioiPZOLKW00amsulY+Mtu1E1y+BrI=";
  };

  nativeBuildInputs = [
    just
    dart-sass
    nodejs
    pnpm.configHook
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-/Th5oN4KTz6ev0eQqmHRdO2HZGN+xfYrt1jOnFkFYTY=";
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
