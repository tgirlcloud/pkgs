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
  version = "0-unstable-2026-02-20";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "3d74daf2199c121db256c41dd7c6745153ee5c88";
    hash = "sha256-c/6KNw8xHdmAtf6YUB1yXZgr7AeFcZcAWU+YHPe844Q=";
  };

  cargoHash = "sha256-dkV9595I3Vkw4saNCkPNW7+fkDC+BYJxOGxLj9ED86A=";

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
