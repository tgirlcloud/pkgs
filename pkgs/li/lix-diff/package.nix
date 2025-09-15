{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "lix-diff";
  version = "1.0.2-unstable-2025-09-14";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "lix-diff";
    rev = "778bab9dade05a58ed2fbc002ff544b7525fd8fd";
    hash = "sha256-6ZjRSa3EBvQimyG2D/yCLgBbBnd9RZsVACM5liZ0+jA=";
  };

  cargoHash = "sha256-ADLLSEzoWttoD30mUOn3k9Ku9gFkzCZr8gJwtu13LFc=";

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
