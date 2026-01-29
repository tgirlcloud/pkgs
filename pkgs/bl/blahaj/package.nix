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
  version = "0-unstable-2026-01-28";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "ec04f87bff1c770123fddd6fead4d2ce14d1ffad";
    hash = "sha256-WiCdIScmJsa31wT4um3/CsEJs9lUf+Tq89elTJ0BUgw=";
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
