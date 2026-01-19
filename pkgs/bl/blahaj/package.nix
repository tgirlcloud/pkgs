{
  lib,
  rustPlatform,
  openssl,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "blahaj";
  version = "0-unstable-2026-01-19";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "d535bfaa17107a0b6bac16a449449434fb7efcf0";
    hash = "sha256-5YFe224uUnaf/P3K4e4+vFIDDoIDpPvBdg3ESmUgCVo=";
  };

  cargoHash = "sha256-EYQWR7q2umCEyJbDhLXNao4yMn+aBQLkVCiwW62LpOU=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  env.BUILD_REV = finalAttrs.version;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "the resident discord bot of hell :3";
    homepage = "https://github.com/isabelroses/blahaj";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "blahaj";
  };
})
