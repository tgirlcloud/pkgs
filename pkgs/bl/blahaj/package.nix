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
  version = "0-unstable-2026-02-21";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "2118c5b29806aa1d8a7efec9caf5ccc3f9ed0306";
    hash = "sha256-GvM1zxTanE6Lx2ywsL3JoLdZDjClacjVp8J2sZ2f3uM=";
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
