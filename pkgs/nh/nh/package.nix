{
  lib,
  nvd,
  rustPlatform,
  installShellFiles,
  makeBinaryWrapper,
  nix-output-monitor,
  fetchFromGitHub,
  nix-update-script,
  use-nom ? true,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nh";
  version = "4.2.0-beta2-unstable-2025-08-18";

  src = fetchFromGitHub {
    owner = "viperml";
    repo = "nh";
    rev = "8d690296fb3b898da565b33455a4227aed8a3133";
    hash = "sha256-IPwAGaR9LO4LasxIFPqOTmIfliDsnzWVgzsaIekzRG4=";
  };

  cargoHash = "sha256-NVtf1TmPcXD9TcMK8zgfO8obn0rGdqdiiG+I4nuXR0I=";

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  postInstall = ''
    mkdir completions

    for shell in bash zsh fish; do
      NH_NO_CHECKS=1 $out/bin/nh completions $shell > completions/nh.$shell
    done

    installShellCompletion completions/*
  '';

  postFixup = ''
    wrapProgram $out/bin/nh \
      --prefix PATH : ${
        lib.makeBinPath (
          [ nvd ]
          ++ lib.optionals use-nom [
            nix-output-monitor
          ]
        )
      }
  '';

  env = {
    NH_REV = finalAttrs.src.rev;
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    license = lib.licenses.eupl12;
    mainProgram = "nh";
    maintainers = with lib.maintainers; [ isabelroses ];
  };
})
