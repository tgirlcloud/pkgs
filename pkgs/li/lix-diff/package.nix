{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "lix-diff";
  version = "1.0.1-unstable-2025-08-12";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "lix-diff";
    rev = "89341f4d117010e425ee481f00cd65bf7ae8101e";
    hash = "sha256-MEHg3qvnwJha619hUHQ4vKfHWY74HPewPAco6EkKH40=";
  };

  cargoHash = "sha256-TVeGN7jTSgWxlU7bdulNNKdwJlnLzNsyT5HuHOGnE78=";

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
