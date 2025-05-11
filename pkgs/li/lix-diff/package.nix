{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "lix-diff";
  version = "0-unstable-2025-05-11";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "lix-diff";
    rev = "8fe41ef1e05fb3ff240033bdaf8aaa31f7b20d92";
    hash = "sha256-pSmSBx25VyV8ymWns29P0hbuFdSLxmAqr53S9adZPQs=";
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
