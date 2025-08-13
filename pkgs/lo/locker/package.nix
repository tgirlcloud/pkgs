{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "locker";
  version = "0-unstable-2025-08-12";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "locker";
    rev = "6b2a641992b67f3a8d847eda8a2a978f46f1439a";
    hash = "sha256-BBY024wS6P4MkKaVl04L3rZDo9iu+Nu6Oi5gl8TKl/g=";
  };

  cargoHash = "sha256-XaSky3qSHi8L09jQaj118BqulLAyGP0fm4Menz/8u8g=";

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
