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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "nixpkgs-prs-bot";
    rev = "10f760d1c9c25230647eba79c489a62439be8ae3";
    hash = "sha256-QmjtU09MEgaZO8h7wfOWTIPmWqyf+2H3NM8XKDfPvKk=";
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
