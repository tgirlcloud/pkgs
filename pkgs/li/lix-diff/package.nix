{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "lix-diff";
  version = "1.0.1-unstable-2025-06-13";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "lix-diff";
    rev = "a55f48a04a9f31b6c48bbd2c8c153559c2022821";
    hash = "sha256-e6FkNR3IOdRCzvDLlelNYIk7Df/3gXKjrnnqsCzANd8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-u3aFmPcceLP7yPdWWoPmOnQEbM0jhULs/kPweymQcZ8=";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    homepage = "";
    description = "generation diffing tool for Lix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "lix-diff";
  };
}
