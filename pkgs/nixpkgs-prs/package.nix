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
  version = "0.5.1-unstable-2025-04-07";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "nixpkgs-prs-bot";
    rev = "19ace0ce5a42333fba7a3f14d9ddec48e1677060";
    hash = "sha256-KDoJ2UNPOt6vVdNhRnXt5ZS47SyAYUzGcOMIXKgnAno=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-PKC9I9T7mYIiDANVXkJRX4ErxJgHXJwl4An3ulx5zVo=";

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
