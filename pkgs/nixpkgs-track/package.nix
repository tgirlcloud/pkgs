{
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  nix-update-script,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "nixpkgs-track";
  version = "0.2.0-unstable-2025-03-27";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "nixpkgs-track";
    rev = "8263e2a2bc6d86cbdf3ae9248f869d7f31f3fd4a";
    hash = "sha256-GxjKmLqp4ZP5xFxWHYYf7wik9t0L55gGtUnToZdJF24=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-06cJY13RGXfU8sBy3CooHPK1/2QDI6qfiNcbZV6ZT2o=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Track where Nixpkgs pull requests have reached";
    homepage = "https://github.com/uncenter/nixpkgs-track";
    license = lib.licenses.mit;
    mainProgram = "nixpkgs-track";
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
