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
  version = "0.1.3-alpha-unstable-2025-07-28";

  src = fetchFromGitHub {
    owner = "k3rs3d";
    repo = "ringfairy";
    rev = "01f7bd2feaa123871d0214569f047c8563538988";
    hash = "sha256-zQkxiBnqMBMnGUF4+3dgs58sip+GubCHuGUPIMrpVfQ=";
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
