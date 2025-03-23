{
  lib,
  just,
  dart-sass,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "isabelroses-website";
  version = "0-unstable-2025-03-22";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "website";
    rev = "6a98c853b596f9e3dc418104f2ce6c3a1685f67e";
    hash = "sha256-08XSI3OR2tyLB9eW0gKc4/dw1RsOW8uvKeLwuLl8uSg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/54qDbFtLSRnZ+WSffPTroXQoUfOilJgE0/Ebh59pHY=";

  nativeBuildInputs = [
    just
    dart-sass
  ];

  dontUseJustInstall = true;
  dontUseJustBuild = true;
  dontUseJustCheck = true;

  preBuild = ''
    just build-styles
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "isabelroses.com";
    homepage = "https://isabelroses.com/";
    license = with lib.licenses; [
      mit
      cc-by-nc-sa-40
    ];
    mainProgram = "isabelroses-website";
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
