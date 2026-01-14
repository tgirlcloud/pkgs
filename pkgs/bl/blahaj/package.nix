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
  version = "0-unstable-2026-01-13";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "b80c842e0997ae0bb190adf4bf201e4c0fde806a";
    hash = "sha256-BgJMMVA4w6TSRWtv98MNxbpwP97OmvbQYteB36uuRAw=";
  };

  cargoHash = "sha256-Tn017S/nrXyq6qk7ClYm1uWiSNtn3PMqbBzx21/9SaA=";

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
