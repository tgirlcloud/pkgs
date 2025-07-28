{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "locker";
  version = "0-unstable-2025-07-27";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "locker";
    rev = "3ff5c7bab0e007c476849c8824c57cc169756b91";
    hash = "sha256-lYjaha/CdpE/xDjRaC3nPtvAru8vywOONV4Oc4GzKJY=";
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
