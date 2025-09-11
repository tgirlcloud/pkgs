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
  version = "0.2.1-alpha-unstable-2025-09-10";

  src = fetchFromGitHub {
    owner = "k3rs3d";
    repo = "ringfairy";
    rev = "dd07799f1b63cd047e8889facf0f562843e08da2";
    hash = "sha256-aXdEWVbmoWIcdnyUzCy5ws2RfbIAwQX/VqG+KuHJjfk=";
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
