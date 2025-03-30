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
  version = "0.2.0-unstable-2025-03-29";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "nixpkgs-track";
    rev = "64295615081229def97fe3ab136bbe161ea3ebac";
    hash = "sha256-PmmOFHjDDyC1rITxOuiMoiFIZqNvGWQ2lSkPqRQxJH4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-06cJY13RGXfU8sBy3CooHPK1/2QDI6qfiNcbZV6ZT2o=";

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
