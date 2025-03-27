{
  lib,
  rustPlatform,
  pkg-config,
  openssl,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "purr";
  version = "1.3.0-unstable-2025-03-26";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "purr";
    rev = "aaeb3d19ae495b9cb25f4b5a2f926726efae887a";
    hash = "sha256-/98eGxJehzAlmpibQAQkBVX9cycHCC/JBDQHHRxGGSc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-7WRNpZ6lYVgLTWL2uqn4aRb7kmX9ZYJQbInIF2uGfvc=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Utility commands for managing userstyles";
    homepage = "https://github.com/uncenter/purr";
    license = lib.licenses.mit;
    mainProgram = "purr";
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
