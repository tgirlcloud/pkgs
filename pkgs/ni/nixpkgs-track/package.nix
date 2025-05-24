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
  version = "0.3.0-unstable-2025-05-23";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "nixpkgs-track";
    rev = "02c9aa6ecc63b30efb0bd388ac9d0c7b38f4f5e9";
    hash = "sha256-elVi+BlqwVwyNbQNNqVfc0Gf5eDYJuULDACqF2L1Dxw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-AbT0r6T2+ag70zEMjN3/2AMK1DfVkLfLAbG9puchD58=";

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
