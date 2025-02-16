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
  version = "0-unstable-2025-02-15";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "website";
    rev = "53126261c25fbb6af1eb6ea1086aa36a4f863685";
    hash = "sha256-cHUkYFhEofGnUVPvkXLlP8DoAscYE8Wlby8Jf48APDQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-QZRNOodvaxIcXmeAWNdq0WVwg8B5fKNtrRvzYqASvMg=";

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
