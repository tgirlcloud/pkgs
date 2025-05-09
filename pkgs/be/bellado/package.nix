{
  lib,
  rustPlatform,
  nix-update-script,
  fetchFromGitHub,
}:
let
  version = "0.3.0";
in
rustPlatform.buildRustPackage {
  pname = "bellado";
  inherit version;

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "bellado";
    rev = "refs/tags/v${version}";
    hash = "sha256-evko1/qE4oRXTMdCOGuwJRUkRm7Sxb5MhQCTLgx5Z+4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ucaYwooJeDpQNBPdX1dK5GI+pwaDLa1g6g61Xy8j+z0=";

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "a todo list manager";
    homepage = "https://github.com/isabelroses/bellado";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "bellado";
  };
}
