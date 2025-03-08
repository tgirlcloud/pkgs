{
  lib,
  rustPlatform,
  openssl,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:
let
  version = "0-unstable-2025-03-07";
in
rustPlatform.buildRustPackage {
  pname = "blahaj";
  inherit version;

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "4a6d5185007405a5c8dfd756ae120152e7b05822";
    hash = "sha256-DfKK6yqyegwgJBNva0S69S+ko21RBIje1TKXlSsILUQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-AySjQZZqoYd8wyukPl/ddzNAhRCK3OhPjwfsGy+qwiA=";

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
