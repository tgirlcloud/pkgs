{
  lib,
  rustPlatform,
  openssl,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:
let
  version = "0-unstable-2025-03-19";
in
rustPlatform.buildRustPackage {
  pname = "blahaj";
  inherit version;

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "49e2937d51f1c0a3b6be783cbf057b6c7d335380";
    hash = "sha256-WIHPBUhuu/wIuSYNKF9JNt3iQfs83aizfVIq+xkYLEs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-sVgPvXzj4ybHxCYsZQ6keJOcjoieRoPJZUbJpnXI5/U=";

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
