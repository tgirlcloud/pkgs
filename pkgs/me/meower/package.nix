{
  lib,
  rustPlatform,
  nix-update-script,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "meower";
  version = "0.4-unstable-2025-02-20";

  src = fetchFromGitHub {
    owner = "Noxyntious";
    repo = "meower";
    rev = "7487fbad6423d9499d6f1b4b49d9097bddd65a6f";
    hash = "sha256-4rD4T10ZUGeqgBork/muG4aqo4Xc/3WhXnUSYXigBd0=";
  };

  cargoHash = "sha256-6TsB7v1fNV2UI/D/d5u1Q/tO9VGFyYfJi8A49qygi5Q=";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Helps you generate your meow mrrrp nya";
    homepage = "https://github.com/Noxyntious/meower";
    mainProgram = "meower";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
