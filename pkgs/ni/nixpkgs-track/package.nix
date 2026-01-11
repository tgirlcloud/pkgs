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
  version = "0.5.0-unstable-2026-01-10";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "nixpkgs-track";
    rev = "bb00d9aa5e574bd747ee352c9b3df3ad92ea1a2a";
    hash = "sha256-HycVA5Eln/9w4PC3FnULvpVXlN1HLOcWsokVLN6ReKQ=";
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
