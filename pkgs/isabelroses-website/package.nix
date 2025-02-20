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
  version = "0-unstable-2025-02-20";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "website";
    rev = "0449f691064ad4e0fdba368e660494f4b05d47f8";
    hash = "sha256-5l7wWrsxksyhMXDr9Mt6Xr4Eus4wdf90L/nB2U44Zho=";
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
