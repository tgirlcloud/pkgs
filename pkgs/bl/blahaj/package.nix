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
  version = "0-unstable-2026-02-22";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "ed59154d92859ac30b0530f5f338e8fae060992d";
    hash = "sha256-J7/UBYKMr38rb0PAOY1gQga7GJKchzsA37S/nWnE10Y=";
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
