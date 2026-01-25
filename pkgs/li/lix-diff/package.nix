{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "lix-diff";
  version = "1.2.0-unstable-2026-01-24";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "lix-diff";
    rev = "9db8e53760fcb25f0f0b1ed7425f80adce9d205a";
    hash = "sha256-ehASke8ZpvHkQI9bCV3/9i1QG67hjSIMoIMQDlbODxU=";
  };

  cargoHash = "sha256-ghwCwIg0PDfUfiHnwiUy8kNjPEgVWk92zA5ZnlD8BO8=";

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
