{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "locker";
  version = "1.0.0-unstable-2026-02-26";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "locker";
    rev = "24c522fa0d62a4d6a52a58a71e397569de3ee15a";
    hash = "sha256-SktDTxXxGZoUEP5Y7BOxF0sdw0dNARN4uowgkkuWCgY=";
  };

  cargoHash = "sha256-JwDFpw14ot4moEbVohRk1ZEeIMeDy4kw/3QECCdkV0E=";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "A linter for your flake.lock file";
    homepage = "https://github.com/isabelroses/locker-lint";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "locker";
  };
})
