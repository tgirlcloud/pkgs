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
  version = "0.5.0-unstable-2025-04-05";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "nixpkgs-prs-bot";
    rev = "3984419c26b21690d92cdd2e05f36c7f78cea052";
    hash = "sha256-5v34f/81WRr3h+sZhVcghNu+pifodZGF87hetNV/wHA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-DDpKckL8coRnD56be19svR3YaN//SxT2rodL+9L8BEg=";

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
