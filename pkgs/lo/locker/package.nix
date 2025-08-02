{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "locker";
  version = "0-unstable-2025-08-01";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "locker";
    rev = "1f922929528463c622d52435471a50f9dd4b63ac";
    hash = "sha256-fjDqsReDxW+8wdkco9RKWaCXyYzay3J3/BzjgZtF7z4=";
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
