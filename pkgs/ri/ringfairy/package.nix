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
  version = "0.2.1-alpha-unstable-2025-08-15";

  src = fetchFromGitHub {
    owner = "k3rs3d";
    repo = "ringfairy";
    rev = "c1828f0c223a8a3c03e8f5b8e195d3628c7e53fe";
    hash = "sha256-JBbPtpR1T8zT85UnWfOwy8hBPVA5pgSs6rYR+1H1t3E=";
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
