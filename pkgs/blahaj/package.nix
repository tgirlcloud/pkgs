{
  lib,
  rustPlatform,
  openssl,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:
let
  version = "0-unstable-2025-04-08";
in
rustPlatform.buildRustPackage {
  pname = "blahaj";
  inherit version;

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "ab1a0a1e050cd5fa17602986a349aa0c37a410f9";
    hash = "sha256-+VcI+PrSMHAVWI1BI8ZvRZ6D/s0n/EAaimFYeIBrifY=";
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
