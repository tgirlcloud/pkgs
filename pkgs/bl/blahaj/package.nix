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
  version = "0-unstable-2026-02-19";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "beef05d1f2bc4ab530b59e16c7f40451534d9873";
    hash = "sha256-eCDhf4w/LXuB+wOz5B1kJ6SJSZGUyVomoA1R72Dq6g4=";
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
