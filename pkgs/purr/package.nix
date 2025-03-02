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
  version = "1.2.0-unstable-2025-03-01";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "purr";
    rev = "cd807c3f1449fcc85d5dea690d09581e55357b22";
    hash = "sha256-ywSHBi3agY5PN9I1RpemWKZQmUfp7K+OP2HxhSCNl0k=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-he9IBE83RJnePs/0lcsr0OtRNEbBnP/UIiGFevIDaWs=";

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
