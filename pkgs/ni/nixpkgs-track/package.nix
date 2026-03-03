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
  version = "0.6.0-unstable-2026-03-02";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "nixpkgs-track";
    rev = "57a60cfd4838217e30f90a7e1c356e90ecd12ff9";
    hash = "sha256-wxmM69bUp98CS4oCYhaliH7fRts9+Ay/JjhuP5IMgeE=";
  };

  cargoHash = "sha256-lnv0nCyb2+7Xl+qAAeaHdbk4XOGdq4FINxPOIPchDhg=";

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
