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
  version = "0-unstable-2025-04-05";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "website";
    rev = "7fe563f37731ef2a6d038550ad7d29b0560d8742";
    hash = "sha256-Yz+XwBrAcS+S70y1eZxlEoB0N9yWDABY40CCm2Fb2rM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-onuopNpvSdEGFpLuKt10rQNjeeIa2hSzjS/J1z8IgVM=";

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
