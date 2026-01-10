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
  version = "0.5.0-unstable-2026-01-09";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "nixpkgs-track";
    rev = "9f9d96e6f9aae7bae5144dcf15cf200b89c1dde1";
    hash = "sha256-h5Bf3Boq3ugTrrdLE90K3vhHesX1O3SxsHb2apWxikc=";
  };

  cargoHash = "sha256-DOQSRRY/ZR4VcHN666Sk8MhJgED61IYzBZTlc37O/M0=";

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
