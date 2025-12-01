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
    rev = "576c2b79981e2a7c526a4cb5f101a3bbd0cc3b94";
    hash = "sha256-eO/bh7R81PpK50bupK0oZ9li1FT5QmZZ65NyOWw2V3w=";
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
