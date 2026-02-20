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
  version = "0.5.1-unstable-2026-02-19";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "nixpkgs-prs-bot";
    rev = "69d1b60331c5402836ba0b81c70fef7c84233691";
    hash = "sha256-PHM8aqZVFM3qa9rARGy0RQBynwH4dW90LnMwPqpCSdE=";
  };

  cargoHash = "sha256-58kDUaGD+MP14Y+yXXXJ6zUs5E/vV3dtWkxPcE72o+M=";

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
