{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "lix-diff";
  version = "0-unstable-2025-05-13";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "lix-diff";
    rev = "0d0519fb7201cfc382f83381f77af764ff945fa5";
    hash = "sha256-1+xSwqPdz0xFPc4hMUP2C56HTJ3VA5lT1i4ooSOoqOU=";
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
