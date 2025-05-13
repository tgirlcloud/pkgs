{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "lix-diff";
  version = "0-unstable-2025-05-12";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "lix-diff";
    rev = "eb77640fed00fb1a4c7cb0cccdca99a4f3822a7b";
    hash = "sha256-b+8U8vcKpKro5MIXbWh3cwsCSm8CHVDSckf6+oj3eoM=";
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
