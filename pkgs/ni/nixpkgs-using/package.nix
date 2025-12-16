{
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  nix-update-script,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "nixpkgs-using";
  version = "0-unstable-2025-12-15";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "nixpkgs-using";
    rev = "353ec7b0984217a2506e48ec9f1acc5f00a41a7a";
    hash = "sha256-MS4nBL4st31mejgjrz9V20jrPJuRGJik9QJJx7X/A84=";
  };

  cargoHash = "sha256-yLHHPeWVLQb43+NLjlc7p7/tYcbWktzVKc+MfjA/xs4=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Find packages that you use that are currently being updated in Nixpkgs";
    homepage = "https://github.com/uncenter/nixpkgs-using";
    license = lib.licenses.mit;
    mainProgram = "nixpkgs-using";
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
