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
  version = "0.4.0-unstable-2025-03-17";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "nixpkgs-prs-bot";
    rev = "2875f74f0711da018b1e0ef99288a68887f39b76";
    hash = "sha256-3qfYYYEmXY2JDhej8SwxqMtdq9R1FXG7ybnVA+I++gs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-pgqMt/HhY0vdJqMgASGmlXVWP4C/bd200PINAZGMIH4=";

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
