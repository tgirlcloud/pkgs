{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "lix-diff";
  version = "1.0.1-unstable-2025-06-15";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "lix-diff";
    rev = "548e54365e083aff84d67eb3cca0447ffbf87f1e";
    hash = "sha256-gR4qa+OLob8BTX5BnI2Ec1QheqRp5TagWM7s9qzv/x4=";
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
