{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "ito";
  version = "0-unstable-2025-01-15";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "ito";
    rev = "ef9b77d5ec1653183ba35bae0d9d3decadbe6ade";
    hash = "sha256-m73wzVwnkFJEPAzCsYvvBD6Ubwmfn6k//sHiA5+E5Sc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-6ekdRqiMKqzkKL4hD3eIA3d6FUSiDIE5yVFOFT8Tx2s=";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "A powerful string manipulation tool";
    homepage = "https://github.com/uncenter/ito";
    license = lib.licenses.mit;
    mainProgram = "ito";
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
