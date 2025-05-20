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
  version = "1.4.0-unstable-2025-05-19";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "purr";
    rev = "2ada4702b390237e4ef18715e2331a0da3fc4667";
    hash = "sha256-e0fdzHRZL5efXzGCzOBh1y9w75fwFsPR0OlqDKWF5V0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-vMfve6/8qMAHIY3h93OXMWx1toX7pfPja0UdC3Y6V9g=";

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
