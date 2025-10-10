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
  version = "0-unstable-2025-10-09";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "d8acec2e0415d3921278e7b26fa6ad1f95aeb132";
    hash = "sha256-LNnAWfYmHOl6GqF7alkCXNNvkImW+lQUbSmOgTI3PJE=";
  };

  cargoHash = "sha256-ZyevutuTtT03L3mhj3LyPpQTjh12h2kQjbz7YscFHqY=";

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
