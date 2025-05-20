{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "lix-diff";
  version = "1.0.1-unstable-2025-05-19";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "lix-diff";
    rev = "3d52194bc78f0d7478c6d1a900f2c806c643b995";
    hash = "sha256-apjYXFdvxLZjhcN1wV7Y/LKNuWtWtCZM0h1VFg/znVo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-u3aFmPcceLP7yPdWWoPmOnQEbM0jhULs/kPweymQcZ8=";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    homepage = "";
    description = "generation diffing tool for Lix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "lix-diff";
  };
}
