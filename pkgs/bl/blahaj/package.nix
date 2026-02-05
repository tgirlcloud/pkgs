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
  version = "0-unstable-2026-02-04";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "742c3372bed4cf2b9ebede3f526487de368057d8";
    hash = "sha256-XF5Jz4XMQ3SyekLVPfTTDgjQY8QTvjpzmZUePhc8Z3M=";
  };

  cargoHash = "sha256-rTOeVzYJgDSkIyAqke82jRJ/PPPnS43QeNT/+TtXUQA=";

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
