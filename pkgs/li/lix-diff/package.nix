{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "lix-diff";
  version = "1.0.1-unstable-2025-06-14";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "lix-diff";
    rev = "a1f6c47169c4520c02c264ed9b529ab99882081f";
    hash = "sha256-PC0znb5Y70XGuXXESYz0RO58rOXktXgQnwxyIzeTJzk=";
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
