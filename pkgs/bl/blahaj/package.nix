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
  version = "0-unstable-2026-04-25";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "29468536965b87d26278a7a230c968714d7ec9dc";
    hash = "sha256-BGntI8Fe3fgtnXMX7SiGbHDqvo/FX5XMcaJbd/y2wo8=";
  };

  cargoHash = "sha256-gNSd+5RdBVjY0YZJhwDmQgfC/0vllIetFufqsGbqyeY=";

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
