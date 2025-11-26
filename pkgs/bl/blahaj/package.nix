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
  version = "0-unstable-2025-11-25";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "df242b650063e77555455f5cfa8c4a71e0a91151";
    hash = "sha256-fhNuVZ5grwH8IA9E+MgCA5E8jouJ6j4+CHjKe+TJHlY=";
  };

  cargoHash = "sha256-OJZyQBH35MYejLDBB0fOM36VnCVpTa28tLoIa4A5yR4=";

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
