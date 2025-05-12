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
    rev = "5cf5e272e8ebe2946041b9caa899c5a338f8beee";
    hash = "sha256-P6VB+PNPPBcjc28xEpuMrybLUGRDb2CrKKb++yzefgg=";
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
