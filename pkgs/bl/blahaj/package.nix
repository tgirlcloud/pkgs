{
  lib,
  rustPlatform,
  openssl,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:
let
  version = "0-unstable-2025-07-09";
in
rustPlatform.buildRustPackage {
  pname = "blahaj";
  inherit version;

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "426ff1f7ceadbe9347d4808d04d6d1362aa9af48";
    hash = "sha256-Hgl4PHjPevWLMdMhSLrdr5PTC2vJH3cxvP2fCixbNNE=";
  };

  cargoHash = "sha256-mgUfLtyrCUiyiv7iFILv8pcKEojJlY1FPpD6q/i0FTM=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  env.BUILD_REV = version;

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
}
