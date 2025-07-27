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
  version = "0.1.3-alpha-unstable-2025-07-26";

  src = fetchFromGitHub {
    owner = "k3rs3d";
    repo = "ringfairy";
    rev = "51ef3a61e9a03bb97e3361dfd509e4052b2ae8d5";
    hash = "sha256-XpNniyLr3VBMuBgCORdsnxdKveMiaGBZ0z5dAcCzpxI=";
  };

  cargoHash = "sha256-rdnTYMdymEqyLU/hG3uoQTT3SOS/SkEOSHJfxMHaPyI=";

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
