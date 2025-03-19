{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "nixpkgs-prs";
  version = "0.5.0-unstable-2025-03-18";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "nixpkgs-prs-bot";
    rev = "e222f4024491725c2ffa04d8db683f4d46da86e2";
    hash = "sha256-iVDiqm3uayg+WBx4phg8GdtzzySWAkraiBnQm/up9Yw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-h3xYdD3j9gu3YA3ffx5rdQKeLDEGZtkv4PnB2XG6DOo=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    homepage = "https://github.com/isabelroses/nixpkgs-prs-bot";
    description = "check the merged nixpkgs PRs for that day";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "nixpkgs-prs";
  };
}
