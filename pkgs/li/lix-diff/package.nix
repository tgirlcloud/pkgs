{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "lix-diff";
  version = "1.5.0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "lix-diff";
    rev = "b98651145d07ace7a29f6e4eba063b71a138e58e";
    hash = "sha256-a/4CwuS3fCURlFkcp3+pKF1oq5VDQanm9sfK50hyJdw=";
  };

  cargoHash = "sha256-1HjmS5wvlX4gGf6AZQnN+37Y3Nf8HVSOHWG2kZCVg1Y=";

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
