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
  version = "0.1.3-alpha-unstable-2025-07-24";

  src = fetchFromGitHub {
    owner = "k3rs3d";
    repo = "ringfairy";
    rev = "54c0d73de9c20a47fd2dadd23d13fe395d434cfb";
    hash = "sha256-Lb6nGASBDoYRfGfgsfrxcBMtrBVFfLFfHbN7UhENgNQ=";
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
