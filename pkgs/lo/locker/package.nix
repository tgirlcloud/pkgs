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
    rev = "12dd7627aaa3a0fed88679e40a6d0c818f3fa9e5";
    hash = "sha256-NsX2PFi60BKXkS8kt2nexe5LMHD2lL9UE8DL4XWiSfQ=";
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
    mainProgram = "locker-lint";
  };
})
