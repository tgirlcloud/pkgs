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
  version = "0.2.1-alpha-unstable-2025-07-31";

  src = fetchFromGitHub {
    owner = "k3rs3d";
    repo = "ringfairy";
    rev = "7bf588659cb64286f6201296cf3e75ea922e67a8";
    hash = "sha256-78ylvRm0xGpAwS/y6YIplBGhv13Vr8xgAUYMtE7hB6I=";
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
