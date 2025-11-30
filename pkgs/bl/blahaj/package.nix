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
  version = "0-unstable-2025-11-30";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "298d4a9a84987ea918a198e95d77657cf2b88e48";
    hash = "sha256-kQhmsioSu+Ex/PLOtT4Co/nBYL/JOxci4brzjZXlG1o=";
  };

  cargoHash = "sha256-IL7RWlfZ/U5ldKwzVeziKJwscCWTl+ffqTl/R+iNvBg=";

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
