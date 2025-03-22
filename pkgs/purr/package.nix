{
  lib,
  rustPlatform,
  pkg-config,
  openssl,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "purr";
  version = "1.2.1-unstable-2025-03-21";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "purr";
    rev = "f94559b7c5340631fc57d17449b82bf75e79b4b1";
    hash = "sha256-9Ve53EYnkKLB5FwBwQFRoKlFLa6FXDAzt2ymIo9eHCc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-2RxfZuzwiBbbb7NwfT/3VEQ2uhB1TNwKu7OHBZ+ybSE=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Utility commands for managing userstyles";
    homepage = "https://github.com/uncenter/purr";
    license = lib.licenses.mit;
    mainProgram = "purr";
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
