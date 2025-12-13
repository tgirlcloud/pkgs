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
  version = "0-unstable-2025-12-12";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "8a6cc46900d571f1b9e3554e99a73eba06fbf9d5";
    hash = "sha256-29+JJc0KQUH780iAG8bXLq4/55E/J2JitTo9aNijShc=";
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
