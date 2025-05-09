{
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  nix-update-script,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "nixpkgs-using";
  version = "0-unstable-2025-04-04";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "nixpkgs-using";
    rev = "b876a1aefb94371c826acca57e28c90701e79486";
    hash = "sha256-OvfP4FY9ecU1pdgvhq5PSOSgEVEQ254GIaxxir+SGZw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-yLHHPeWVLQb43+NLjlc7p7/tYcbWktzVKc+MfjA/xs4=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Find packages that you use that are currently being updated in Nixpkgs";
    homepage = "https://github.com/uncenter/nixpkgs-using";
    license = lib.licenses.mit;
    mainProgram = "nixpkgs-using";
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
