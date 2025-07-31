{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "ringfairy";
  version = "0.2.1-alpha-unstable-2025-07-30";

  src = fetchFromGitHub {
    owner = "k3rs3d";
    repo = "ringfairy";
    rev = "1b01f22eed99e1b0a2cdef1f3de7bf7254fc3a0d";
    hash = "sha256-ueIa/jUlmY9ABdw+GPwkLQ1PpoGdA9fb/bTe7f50LbU=";
  };

  cargoHash = "sha256-I+U5Fkh5jI6Vcq1hx+GRzqfbUFaeXzLHdXzcIXia7Dc=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Static webring generator in Rust";
    homepage = "https://github.com/k3rs3d/ringfairy";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "ringfairy";
  };
}
