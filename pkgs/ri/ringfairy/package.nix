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
  version = "0.1.3-alpha-unstable-2025-07-09";

  src = fetchFromGitHub {
    owner = "k3rs3d";
    repo = "ringfairy";
    rev = "1fd4e1932599a54f27322ac95523a6b13c11d69a";
    hash = "sha256-qnoFuiUwMhjkrIvommP2V/ysZ7opSJADB/I9dBozt7A=";
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
