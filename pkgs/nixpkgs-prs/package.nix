{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "nixpkgs-prs";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "nixpkgs-prs-bot";
    rev = "771a46c84fc48c8bda085593ebfd427d8d7db989";
    hash = "sha256-IwnBqjdBilqeRJvXF8zNzrO7zKkCsN2pHSpf9uHchnU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-h4rVyfrjajlsxcWB2WCPuhUdpMlPu1VxfKmEUY5g9ic=";

  nativeBuildInputs = [
    pkg-config
    versionCheckHook
  ];

  buildInputs = [
    openssl
  ];

  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/nixpkgs-prs";
  versionCheckProgramArg = [ "--version" ];

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
