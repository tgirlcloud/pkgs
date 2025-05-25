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
  version = "0-unstable-2025-05-24";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "website";
    rev = "2fd1ed61ca4d8dd82b0f166ab6459771bab6bde1";
    hash = "sha256-4gwN27RbK5Z6NmW6mydbbQOHN8tqaBmQq2RYpm/8FOE=";
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
