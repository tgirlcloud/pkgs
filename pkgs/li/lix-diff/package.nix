{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "lix-diff";
  version = "1.4.1-unstable-2026-03-09";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "lix-diff";
    rev = "d7ed019c8f0f3c2cfe74e66c112fee1a7bb96a0a";
    hash = "sha256-aLmCS+Q6B/DU6DZ0U/FfCOovwZTSTAG5vrCGHZ1Xsrk=";
  };

  cargoHash = "sha256-g50St9tX2IYaPmnjSE8AeSKqUF5Ou87Y5F0zVBK3Xxo=";

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
