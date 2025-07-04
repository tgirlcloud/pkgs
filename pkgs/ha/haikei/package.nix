{
  lib,
  rustPlatform,
  nix-update-script,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "haikei";
  version = "0-unstable-2025-06-29";

  src = fetchFromGitHub {
    owner = "comfysage";
    repo = "haikei";
    rev = "9c724d48c27ad0ccadde64e6610b329051954426";
    hash = "sha256-c39hmUGq6BjtG7Rjui0W6M5VI/aSRw585P3Za3PFv6k=";
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
