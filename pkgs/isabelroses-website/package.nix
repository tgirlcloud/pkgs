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
  version = "0-unstable-2025-03-18";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "website";
    rev = "59337fffcbc4d56ac01327457677d359f8bcc690";
    hash = "sha256-A/ifcKX5cKwBj1/q/fJU5+hcNB9QW6ofUZrO7WE8m3c=";
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
