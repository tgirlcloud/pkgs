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
  version = "1.3.0-unstable-2025-04-01";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "purr";
    rev = "69a9c30099266373b50796ba354fbd7083737d2a";
    hash = "sha256-BR+Wovbskm9x1+hyHMVNwPQPrp+voI9JHYLiE/VA6BE=";
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
