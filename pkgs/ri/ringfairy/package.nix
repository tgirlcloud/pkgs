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
  version = "0.2.1-alpha-unstable-2026-03-06";

  src = fetchFromGitHub {
    owner = "k3rs3d";
    repo = "ringfairy";
    rev = "004322e509588f31888acc66f2bd91ecb009f57a";
    hash = "sha256-OV5eRbBE71vKjg6AG4ymJ3vKEREqPDquMHWYD7SKFtU=";
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
