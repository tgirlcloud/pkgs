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
  version = "1.4.0-unstable-2026-01-25";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "purr";
    rev = "e2642185231d36f84afd76ddf4afe8abdb19a54a";
    hash = "sha256-oQX5jDwChQIgskwUB5snScn5ZDmLlQedfaFJYIl7PDk=";
  };

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
