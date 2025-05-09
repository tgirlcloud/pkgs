{
  lib,
  rustPlatform,
  openssl,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:
let
  version = "0-unstable-2025-04-10";
in
rustPlatform.buildRustPackage {
  pname = "blahaj";
  inherit version;

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "ac3d07c7e646d67f7cec4d334b0a348cbedd90a0";
    hash = "sha256-HyA/w1uGR4AT7iQqd8SJ4T8bMG/aX4Uuk/o/rl41IY8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-+wsA7fu1yOU0CEt7JzzgA0OUmX3M/mV2s4cJEfEshZ0=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  env.BUILD_REV = version;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "the resident discord bot of hell :3";
    homepage = "https://github.com/isabelroses/blahaj";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "blahaj";
  };
}
