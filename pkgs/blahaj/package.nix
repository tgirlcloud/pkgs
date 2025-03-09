{
  lib,
  rustPlatform,
  openssl,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:
let
  version = "0-unstable-2025-03-08";
in
rustPlatform.buildRustPackage {
  pname = "blahaj";
  inherit version;

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "23af8d8f9e34c1a7fa7bf80f0142560bcffd581d";
    hash = "sha256-SE9G4rvp9UPqkPA0NUxlnnm2oa2ewXoQY9iDIfvo7Go=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-8Deh5eDB18yGnO5GjD0o+8tX53w9qfZn5AQhJHAZD3I=";

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
