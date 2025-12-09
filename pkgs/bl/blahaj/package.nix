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
  version = "0-unstable-2025-12-08";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "55d1a92088b8fff4363d4530bd25f5edc1409bb1";
    hash = "sha256-mY0mxN4s6Rtx7BDxyeH+HMfTl3cIKL0SjBlpiSm9pxQ=";
  };

  cargoHash = "sha256-xC52xPK8kj1mLHUVdoOHi5r66EfGqfs7MQkLGT2n9RU=";

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
