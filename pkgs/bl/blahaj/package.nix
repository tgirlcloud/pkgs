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
  version = "0-unstable-2025-09-03";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "af3004863cac0ba623ed8280a4f1c8482da5250a";
    hash = "sha256-rzqvEF/UEVUlMSXq/2pM5h3bSrAjfSlADMLsrEHd+uE=";
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
