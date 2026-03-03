{
  lib,
  pnpm,
  just,
  nodejs_22,
  stdenvNoCC,
  fetchPnpmDeps,
  pnpmConfigHook,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "isabelroses-website";
  version = "0-unstable-2026-03-02";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "website";
    rev = "aba70d34480053b7a3b5d586ae6cfab062f48f52";
    hash = "sha256-3pvEhYnX591Ofn/QWR9ekKJDxm18q3V5fD5ZuH/57xk=";
  };

  nativeBuildInputs = [
    just
    pnpm
    nodejs_22
    pnpmConfigHook
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-yx5b3imvpzhXqDQYksZ8n47zszEvbiodDPOTCyIn+T4=";
    fetcherVersion = 3;
  };

  dontUseJustInstall = true;
  dontUseJustCheck = true;

  env.ASTRO_TELEMETRY_DISABLED = 1;

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
