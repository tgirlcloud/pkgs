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
  version = "0-unstable-2026-03-25";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "f6f09aff36712f9d1b89aa56fc4a8d9374af8b77";
    hash = "sha256-y/azde899z3mfJNM6wcjyKOdxZkfIEFcCqXVGyq3lro=";
  };

  cargoHash = "sha256-D3rHFTuBSq4BtUiYPbEbLOqLhC77nhpjjJYzJloahCg=";

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
