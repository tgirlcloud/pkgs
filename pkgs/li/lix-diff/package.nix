{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "lix-diff";
  version = "1.1.1-unstable-2025-12-05";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "lix-diff";
    rev = "321455334189f269afd24f6ef656d194509607f1";
    hash = "sha256-uZd8xoQWsvJCmHtxtKJzKtaupUdXMXKWqSjXnK/BZco=";
  };

  cargoHash = "sha256-ydB65V879tW42FXSgdoUDeQbovsVf8qXku9uW4mqAfs=";

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
