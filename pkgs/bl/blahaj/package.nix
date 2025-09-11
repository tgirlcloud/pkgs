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
  version = "0-unstable-2025-09-10";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "461dcc3bf99985e2a7385a408ef543620c9d29e3";
    hash = "sha256-JVIDk4t0hgSrni5DYjon8ULxmPczXzB+iW1hMcQNqX0=";
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
