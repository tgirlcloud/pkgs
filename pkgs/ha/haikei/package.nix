{
  lib,
  rustPlatform,
  nix-update-script,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "haikei";
  version = "0-unstable-2025-07-30";

  src = fetchFromGitHub {
    owner = "comfysage";
    repo = "haikei";
    rev = "2710b16f3bb3ad73b316198927b0fbab3f291bf2";
    hash = "sha256-6ADi1ZwZr8A0ThgjnXFggCPzaOyUzRATMVXznPzUHPc=";
  };

  cargoHash = "sha256-ogMGYB7iKh9SfRxGF+hS3CM4cHpcPKG2AABw55+MCTk=";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "tiny wallpaper helper";
    homepage = "https://github.com/comfysage/haikei";
    license = with lib.licenses; [ mit ];
    maintainers = [ { name = "comfysage"; } ];
    mainProgram = "haikei";
  };
}
