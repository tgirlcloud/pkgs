{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "lix-diff";
  version = "0-unstable-2025-05-14";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "lix-diff";
    rev = "b90d6d6ab1f14c5dcd9d4f213643d39033ea5c1f";
    hash = "sha256-NtGYbrF7BwJejnkGAGKl3cEbEE3gHP5B2oByihbXVyg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-44BTa1eN2XJeyVYw0aAJXbIbzRJa8+J/6ZnbbRaRhxE=";

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
