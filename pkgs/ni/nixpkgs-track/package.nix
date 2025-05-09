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
  version = "0.2.0-unstable-2025-03-30";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "nixpkgs-track";
    rev = "83c58c8e42597eaf28d5ad00f98b8dc6ece8722d";
    hash = "sha256-zusycXqn33CUgIOsnpa3oYZqXRKSRy8joYQ4tT1usww=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-pA+ggS3xlxhcFSAtlLtx4HVGnE+ruo67zQz8yxDMttA=";

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
