{
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  nix-update-script,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "nixpkgs-track";
  version = "0.6.0-unstable-2026-04-11";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "nixpkgs-track";
    rev = "4004942844d4f9dad3c98723cd048dcb09a6f3a2";
    hash = "sha256-qPSzlx0QWkaLynwU5glcTliyJN7kJ6aCUCTVcT03kic=";
  };

  cargoHash = "sha256-lnv0nCyb2+7Xl+qAAeaHdbk4XOGdq4FINxPOIPchDhg=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Track where Nixpkgs pull requests have reached";
    homepage = "https://github.com/uncenter/nixpkgs-track";
    license = lib.licenses.mit;
    mainProgram = "nixpkgs-track";
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
