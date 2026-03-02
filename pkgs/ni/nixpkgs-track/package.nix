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
  version = "0.5.0-unstable-2026-03-01";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "nixpkgs-track";
    rev = "86a08dc299728523b735fcb0269e33acadb9cdf4";
    hash = "sha256-wRvD1keq6fejUWIBkLl1PeUe5nlHiuGLUG/5b+oCNkY=";
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
