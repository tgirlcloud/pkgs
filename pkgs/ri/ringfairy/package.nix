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
  version = "0.2.0-alpha-unstable-2025-07-29";

  src = fetchFromGitHub {
    owner = "k3rs3d";
    repo = "ringfairy";
    rev = "e21c68de023548896e6faa79d295121b5e9d64ca";
    hash = "sha256-TanWLuaeTPM/1dvTvqRy5fqHTY0yf7IcjdV4Wh+BZ28=";
  };

  cargoHash = "sha256-zBbFsxS0sjtSd+dKUCwzBdKDdPbxQr5X/4OQcQoPS/I=";

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
